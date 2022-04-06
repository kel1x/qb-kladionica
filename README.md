# qb-kladionica
- Sports Betting / Kladionica [FiveM] | Optimised > 0.00ms

- Credits to : https://github.com/tomiichx/tomic_kladionica

- Check out his version ! [ESX]

Add this to qb-core>shared>jobs.lua in order to work:


	['kladionica'] = {
		label = 'Kladionica',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Zaposlen',
                payment = 50
            },
            ['1'] = {
                name = 'Obezbedjenje',
                payment = 75
            },
            ['2'] = {
                name = 'Konobar',
                payment = 75
            },
            ['3'] = {
                name = 'Gazda',
                payment = 100
            },
        },
    },  
