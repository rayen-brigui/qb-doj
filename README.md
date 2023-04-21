# qb-Doj
DOJ script that allows judge to :
-recruite/promote lawyers 
-announce trial
-use gavel at court
-and lawyer have access to DOJ vehicle

*********

-----> add the next code to "\[qb]\qb-core\shared\jobs.lua" :

QBShared.Jobs={
    ['doj'] = {
		label = 'Doj',
		defaultDuty = true,
		offDutyPay = true,
		grades = {
            ['0'] = {
                name = 'Associate Lawyer',
                payment = 1500
            },
            ['1'] = {
                name = 'Junior Lawyer',
                payment = 2500
            },
            ['2'] = {
                name = 'Senior Lawyer',
                payment = 3500
            },['3'] = {
                name = 'Judge',
                isboss = true,
                payment = 5000
            },
        },
	},
    }

