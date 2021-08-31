const { readFile } = require('fs/promises')

async function parse () {
  const buf = await readFile('bad.bin')
  
  const buf2 = Buffer.from([
    0x6C, 0xB2, // wait 0x6CB2 (27826ms)
    0x90, 0x4B, // play 0x4B (75) note
    0x00, 0xD9, // wait 0xD9
    0x90, 0x4D, // play 9x4D
    0x00, 0xD9  // wait 0xD9
  ])
  
  const notes = []
  let lastNote = 0
  for (let i = 0; i < buf.length; i++) {
    const first = buf.readUInt8(i)
    if (first === 0x90) {
      lastNote = buf.readInt8(i+1)
      console.log('read', lastNote.toString(16))
      i += 1
    } else if (first === 0x80) {
      lastNote = 0
    } else if (first === 0xF0) {
      console.log('END')
      break
    } else {
      const read = buf.readUInt16BE(i)
      console.log('wait', read)
      notes.push(lastNote, read)
      i += 1
    }
  }
  
  console.log(notes.join(','))
  console.log(notes.length / 2)

}

parse().catch(console.log)
