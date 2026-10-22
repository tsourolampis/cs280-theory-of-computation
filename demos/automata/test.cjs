// No dependencies: tests execute the exact core embedded in the shipped HTML.
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
const html=fs.readFileSync(__dirname+'/index.html','utf8');
const core=html.match(/<script id="automata-core">([\s\S]*?)<\/script>/)[1];
vm.runInThisContext(core);
let checks=0;
const predicates=[w=>[...w].filter(a=>a==='1').length%3===1,w=>/^(0*1|1*0)$/.test(w),w=>/^(01)*$/.test(w)];
examples.forEach((m,i)=>{const d=convert(m);for(const w of words(m.alphabet,10)){const expected=predicates[i](w);assert.equal(accepts(m,w),expected);assert.equal(acceptsDFA(d,w),expected);const f=execution(m,w).at(-1);assert.equal(f.s.some(q=>m.finals.includes(q)),expected);assert.equal(f.pos,w.length);checks++;}assert.equal(d.steps.length,d.sets.length*m.alphabet.length);for(const s of d.sets)for(const a of m.alphabet)assert.ok(d.sets.some(t=>key(t)===d.delta[key(s)][a]));});
assert.deepEqual(closure(examples[2],['p']),['p','q']);
assert.deepEqual(closure(examples[2],[]),[]);
assert.ok(convert(examples[2]).sets.some(s=>s.length===0));
assert.throws(()=>accepts(examples[0],'2'));
// Independent configuration-graph traversal: epsilon transitions and symbol
// consumption are explored separately, without calling closure or move.
function oracle(m,w){const todo=[[m.start,0]],seen=new Set();while(todo.length){const [q,i]=todo.pop(),k=JSON.stringify([q,i]);if(seen.has(k))continue;seen.add(k);if(i===w.length&&m.finals.includes(q))return true;for(const t of m.delta[q]?.['']||[])todo.push([t,i]);if(i<w.length)for(const t of m.delta[q]?.[w[i]]||[])todo.push([t,i+1]);}return false;}
let seed=280;function rand(){seed=(Math.imul(seed,1664525)+1013904223)>>>0;return seed/2**32;}
for(let j=0;j<100;j++){const states=['a','b','c','d'],m={states,alphabet:['0','1'],start:'a',finals:states.filter(()=>rand()<.4),delta:{}};for(const q of states){m.delta[q]={};for(const a of ['','0','1'])m.delta[q][a]=states.filter(()=>rand()<.25);}const d=convert(m);for(const w of words(m.alphabet,6)){assert.equal(acceptsDFA(d,w),oracle(m,w));assert.equal(accepts(m,w),oracle(m,w));checks++;}}
assert.equal(checkExamples(),1533);
console.log('PASS: '+checks+' word cases; independent predicates, 100 seeded epsilon-NFAs, traces, cycles, trap state, empty word and invalid input.');
