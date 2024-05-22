# fxScratchCards

![fxscratchcards_thumbnail](https://github.com/Fifly1/fxScratchCards/assets/107129715/752b000f-f16d-4c9e-974d-cc2f6e41a9f7)

Free esx/qb scratch cards script for FiveM.

|Preview| [Preview](https://youtu.be/d85DpvlZIe8)

If you are using QBCORE add this in your qb-core/shared/items.lua:

['fx_scratchcard']                     = {['name'] = 'fx_scratchcard',                       ['label'] = 'Scratch Card',              ['weight'] = 0,            ['type'] = 'item',         ['image'] = 'fx_scratchcard.png',             ['unique'] = false,         ['useable'] = true,     ['shouldClose'] = true,     ['combinable'] = nil,   ['description'] = 'A scratch card.'},

If you are using ESX add this to your database:

INSERT INTO `items` (name, label) VALUES
  ('fx_scratchcard','Scratch Card')
;

If you have any problems, questions or ideas you can make a ticket in the [Discord](https://discord.com/invite/5UZfvsbHHK) server.
