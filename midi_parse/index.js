const midiParser = require('midi-parser-js')

const { readFile } = require('fs/promises')

async function parse () {
  const data = await readFile('bad.mid', 'base64')
  const midiArray = midiParser.parse(data)
  
  console.log(midiArray.track[1].event)

}

parse().catch(console.log)
