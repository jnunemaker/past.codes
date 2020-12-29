# frozen_string_literal: true

namespace :mailer do
  task preview: :environment do
    starred_repositories = [
      {
        starredAt: Time.zone.today - 6.months,
        era: '6 months ago',
        repository: {
          owner: 'pelya',
          name: 'commandergenius',
          description: 'Port of SDL library and several games to the Android OS.',
          primary_language: {
            name: 'C'
          }
        }
      },
      {
        starredAt: Time.zone.today - 6.months,
        era: '6 months ago',
        repository: {
          owner: 'kivikakk',
          name: 'koino',
          description: 'CommonMark + GFM compatible Markdown parser and renderer',
          primary_language: {
            name: 'Zig'
          },
          funding_links: [
            {
              "platform": 'GITHUB',
              "url": 'https://github.com/kivikakk'
            }
          ]
        }
      },
      {
        starredAt: Time.zone.today - 1.year,
        era: '1 year ago',
        repository: {
          owner: 'curl',
          name: 'curl'
        }
      },
      {
        starredAt: Time.zone.today - 2.years,
        era: '2 years ago',
        repository: {
          owner: 'jekyll',
          name: 'jekyll'
        }
      }
    ]
    pp ReminderMailer.reminder_email(ENV['TEST_EMAIL_ADDRESS'], 'gjtorikian', starred_repositories)
  end
end
