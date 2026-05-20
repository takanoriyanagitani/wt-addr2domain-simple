//@ts-expect-error
import { readFile } from "node:fs/promises";

(async () => {
	/** @type {string} */
	const wasm = "./addr2domain.wasm";

	const pbytes = readFile(wasm);
	const pwasm = pbytes.then(WebAssembly.instantiate);

	const { instance } = await pwasm;
	const { exports } = instance;
	const { addr2domain, memory } = exports;

  const args = process.argv;
  if(3 !== args.length) return; // addr missing

  const addr = args[2];

  const enc = new TextEncoder();
  const encoded = enc.encode(addr);
  const elen = encoded.length;

  const view = new Uint8Array(memory.buffer);
  const start = 0;
  const end = start + elen;
  view.set(encoded, start);

  const newstart = addr2domain(start, end);
  if(0 === newstart) return; // "@" not found

  const newlen = end - newstart;
  if(newlen < 1) return; // not a valid string

  const oview = new Uint8Array(memory.buffer, newstart, newlen);

  const dec = new TextDecoder();
  const decoded = dec.decode(oview);

  console.info(decoded);

})();
