# frozen_string_literal: true

namespace :editor do
  desc 'Grant editor permissions'
  task :grant, [:user] => :environment do |_task, args|
    set_admin(args.user, true)
  end

  desc 'Revoke editor permissions'
  task :revoke, [:user] => :environment do |_task, args|
    set_admin(args.user, false)
  end

  def set_admin(email, is_admin)
    user = User.find_by(email: email)
    user.editor = is_admin
    user.save!
    puts email + ' is editor: ' + is_admin.to_s
  rescue StandardError => e
    puts e
  end
end
