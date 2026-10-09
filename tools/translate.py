#!/usr/bin/env python3
"""Static translation of every known original instruction into portable JS.
No runtime x86 fetch/decode; every operand and control-flow edge is emitted here.
"""
from pathlib import Path
import re,json,hashlib
from capstone import Cs,CS_ARCH_X86,CS_MODE_16
from capstone.x86 import X86_OP_REG,X86_OP_IMM,X86_OP_MEM
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/generated';OUT.mkdir(parents=True,exist_ok=True)
raw=(ROOT/'build/CAT.EXE').read_bytes();assert hashlib.sha256(raw).hexdigest()=='4979c8867826e08881d1d4bec95c95d6bc1ac70fd21050ccdb4f733a50d7bfdd','Unexpected game binary';cs=Cs(CS_ARCH_X86,CS_MODE_16);cs.detail=True
ips=sorted({int(m[1],16) for p in (ROOT/'game/asm/code').rglob('*.asm') for m in re.finditer(r'; ([0-9a-f]{4}): [0-9a-f ]+$',p.read_text(),re.M)})
ins={ip:next(cs.disasm(raw[0x7430+ip:],ip,count=1)) for ip in ips}
# Relocated immediates are emitted with the fixed load segment of this translated runtime.
relocs={int.from_bytes(raw[0x1c+i*4:0x1e+i*4],'little') for i in range(9)}
regs=['ax','cx','dx','bx','sp','bp','si','di','es','cs','ss','ds']
def reg(r):
 n=cs.reg_name(r)
 if n in regs:return f'c.r[{regs.index(n)}]'
 n16=n[0]+'x';idx=regs.index(n16)
 return f'(c.r[{idx}]'+ ('&255)' if n[1]=='l' else '>>>8)')
def address(o,offset=False):
 m=o.mem;seg=cs.reg_name(m.segment) if m.segment else ('ss' if cs.reg_name(m.base)=='bp' else 'ds')
 terms=[reg(x) for x in (m.base,m.index) if x]
 terms.append(str(m.disp));off='('+ '+'.join(terms)+')&65535'
 return '('+off+')' if offset else f'(c.r[{regs.index(seg)}]*16+({off}))&1048575'
def val(o,i):
 if o.type==X86_OP_REG:return reg(o.reg)
 if o.type==X86_OP_IMM:return str((o.imm+0x1000 if i.address+1 in relocs else o.imm)&((1<<(8*(o.size or i.operands[0].size or 2)))-1))
 return f'c.m{o.size*8}({address(o)})'
def put(o,v):
 if o.type==X86_OP_MEM:return f'c.w{o.size*8}({address(o)},{v});'
 n=cs.reg_name(o.reg)
 if n in regs:return f'c.r[{regs.index(n)}]=({v})&65535;'
 idx=regs.index(n[0]+'x');return f'c.r[{idx}]=(c.r[{idx}]&{65280 if n[1]=="l" else 255})|(({v}&255){"<<8" if n[1]=="h" else ""});'
conds={'je':'c.z','jne':'!c.z','jb':'c.f&1','jae':'!(c.f&1)','ja':'!(c.f&1)&&!c.z','jbe':'(c.f&1)||c.z'}
blocks={};edges={0}
for ip,i in ins.items():
 n=i.mnemonic
 if n.startswith('j') or n in ('call','ret','retf','iret','int','loop','loope','loopne') or n.startswith('rep'):
  edges.add(ip+i.size)
  if i.operands and i.operands[0].type==X86_OP_IMM and n!='int':edges.add(i.operands[0].imm&65535)
# Limit function size so V8 can optimize each page rather than an enormous switch.
for ip,i in ins.items():
 n=i.mnemonic;o=i.operands;v=[val(x,i) for x in o];w=o[0].size*8 if o else 16;nextip=ip+i.size
 s=f'case {ip}: c.ip={nextip};'
 if n=='mov':s+=put(o[0],v[1])
 elif n in ('add','adc','sub','and','or','xor','inc','dec','neg','shl','shr','rcl','rcr'):
  s+=put(o[0],f'c.alu("{n}",{v[0]},{v[1] if len(v)>1 else 1},{w})')
 elif n in ('cmp','test'):s+=f'c.alu("{n}",{v[0]},{v[1]},{w});'
 elif n=='not':s+=put(o[0],f'~{v[0]}')
 elif n=='xchg':s+=f't={v[0]};'+put(o[0],v[1])+put(o[1],'t')
 elif n=='push':s+=f'c.push({v[0]});'
 elif n=='pop':s+='t=c.pop();'+put(o[0],'t')
 elif n=='call':s+=f'c.push({nextip});c.ip={v[0]};'
 elif n=='jmp':s+=f'c.ip={v[0]};'
 elif n in conds:s+=f'if({conds[n]})c.ip={v[0]};'
 elif n.startswith('loop'):s+=f'c.r[1]=(c.r[1]-1)&65535;if(c.r[1]{"&&c.z" if n=="loope" else "&&!c.z" if n=="loopne" else ""})c.ip={v[0]};'
 elif n=='ret':s+='c.ip=c.pop();'
 elif n=='retf':s+='c.ip=c.pop();c.r[9]=c.pop();'
 elif n=='iret':s+='c.ip=c.pop();c.r[9]=c.pop();c.f=c.pop();'
 elif n=='ljmp':s+='throw Error("Guest requested BIOS reset");'
 elif n=='mul':s+=f'c.mul({v[0]},{w});'
 elif n=='int':s+=f'c.interrupt({o[0].imm});'
 elif n=='in':s+=put(o[0],f'c.input({v[1]})')
 elif n=='out':s+=f'c.output({v[0]},{v[1]});'
 elif n=='pushf':s+='c.push(c.f);'
 elif n=='popf':s+='c.f=c.pop()|2;'
 elif n=='lahf':s+='c.r[0]=(c.r[0]&255)|((c.f&213|2)<<8);'
 elif n=='sahf':s+='c.f=(c.f&~213)|((c.r[0]>>>8)&213)|2;'
 elif n=='aaa':s+='c.aaa();'
 elif n in ('clc','stc','cld','std','cli','sti'):s+=f'c.f{ "&=~" if n in ("clc","cld","cli") else "|="}{1 if n in ("clc","stc") else 1024 if n in ("cld","std") else 512};'
 elif n=='nop':pass
 elif any(k in n for k in ('stos','movs','lods','scas')):
  seg=8 if 0x26 in i.prefix else 9 if 0x2e in i.prefix else 10 if 0x36 in i.prefix else 11
  s+=f'c.string("{n}",{seg});'
 else:raise Exception((ip,n))
 s+='return;'
 blocks.setdefault(ip>>8,[]).append(s)
lines=['// Generated from game/asm/code and the matching executable. Do not edit.','export const boundaries=new Set('+json.dumps(sorted(edges))+');','export const pages=[];']
for page,body in blocks.items():lines.append(f'pages[{page}]=function(c){{let t;switch(c.ip){{'+ '\n'.join(body)+'default:throw Error("Untranslated instruction "+c.ip.toString(16));}};')
(OUT/'package.json').write_text('{"type":"module"}\n')
(OUT/'translated.js').write_text('\n'.join(lines)+'\n')
(OUT/'translation-manifest.json').write_text(json.dumps({'instructions':len(ins),'pages':len(blocks),'sha256':hashlib.sha256(raw).hexdigest()},indent=2))
print(f'Translated {len(ins)} instructions into {len(blocks)} JS pages')
