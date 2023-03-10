import { writeFile } from 'fs/promises'
import { config } from 'dotenv'
import { load } from 'cheerio'
import pkg from 'json-2-csv'
const { json2csvAsync: json2csv } = pkg

config({ path: '/home/hbauer/scripts/ufc-events/.env' })

const html = await fetch(process.env.REMOTE_ENDPOINT)
const $ = load(await html.text())

const events = []

const rows = $('.b-statistics__table-events tbody tr')

rows.slice(1).each(function () {
  const [$nameAndDate, $location] = $(this).find('td')
  const name = $($nameAndDate).find('a').text().trim()
  const date = $($nameAndDate).find('span').text().trim()
  const location = $($location).text().trim()
  events.push({ name, date, location })
})

const _dirname = new URL('../', import.meta.url).pathname
await writeFile(`${_dirname}ufc-events.csv`, await json2csv(events))
