[Apply, Job, Geek, Company].each do |model|
  model.delete_all
  model.reset_pk_sequence # метод из гема activerecord-reset-pk-sequence
end

Company.create!([
                  { name: 'MoGo', location: 'New York' },
                  { name: 'Wirkkle',     location: 'London' },
                  { name: 'Artesis',     location: 'Saint-Petersburg' },
                  { name: 'BuildEmpire', location: 'London' }
                ])

Job.create!([
              { name: 'Sinatra React', place: 'Remote', company_id: 1 },
              { name: 'Ruby React',          place: 'Contract',  company_id: 2 },
              { name: 'React',               place: 'Remote',    company_id: 3 },
              { name: 'Node React',          place: 'Permanent', company_id: 1 },
              { name: 'Ruby on Rails',       place: 'Remote',    company_id: 4 },
              { name: 'Node',                place: 'Permanent', company_id: 4 },
              { name: 'Javascript CSS HTML', place: 'Permanent', company_id: 4 }
            ])

Geek.create!([
               { name: 'Mike',   stack: 'Sinatra React', resume: '3 years Sinatra' },
               { name: 'Alex',   stack: 'Ruby React', resume: '2 years Ruby' },
               { name: 'Martha', stack: 'Rails' },
               { name: 'Juri',   stack: 'Java', resume: '5 years Java' },
               { name: 'Andrew', stack: 'PHP' },
               { name: 'Nina',   stack: 'Node',          resume: 'Node, Express' },
               { name: 'Bob',    stack: 'Front end',     resume: 'Vue, React' },
               { name: 'Kate',   stack: 'PHP' },
               { name: 'Boris',  stack: 'Full stack', resume: 'Rails + React' }
             ])

Apply.create!([
                { job_id: 1, geek_id: 1, read: true, invited: true },
                { job_id: 1, geek_id: 2, read: false, invited: false },
                { job_id: 5, geek_id: 5, read: true,  invited: false },
                { job_id: 6, geek_id: 8, read: false, invited: false }
              ])
