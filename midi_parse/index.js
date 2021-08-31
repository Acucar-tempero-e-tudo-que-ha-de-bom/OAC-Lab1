const { readFile } = require('fs/promises')

async function parse (filepath) {
  const buf = await readFile(filepath)
  
  const notes = []
  let lastNote = 0
  for (let i = 0; i < buf.length; i++) {
    const first = buf.readUInt8(i)
    if (first === 0x90) {
      lastNote = buf.readInt8(i+1)
      console.log('read', lastNote.toString(16))
      i += 1
    } else if (first === 0x91 || first === 0x92) {
      i += 1
    } else if (first === 0x80) {
      lastNote = 0
    } else if (first === 0x81 || first === 0x82) {
      continue
    } else if (first === 0xF0) {
      console.log('END')
      break
    } else {
      console.log(first.toString(16))
      const read = buf.readUInt16BE(i)
      console.log('wait', read)
      notes.push(lastNote, read)
      i += 1
    }
  }
  
  console.log(notes.join(','))
  console.log(notes.length / 2)

}

parse(process.argv[process.argv.length - 1]).catch(console.log)
