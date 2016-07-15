namespace :permissions do
    desc "Restore editor permissions"
    task :give, [:user] => :environment do |task, args|
        set_admin(args.user, true)
    end

    desc "Revoke editor permissions"
    task :revoke, [:user] => :environment do |task, args|
        set_admin(args.user, false)
    end
    
    def set_admin(email, is_admin)
        begin
            user = User.find_by(email: email)
            user.editor = is_admin
            user.save!
            puts email + " is admin: " + is_admin.to_s
        rescue Exception => e
            puts e
        end
    end
end
