namespace :permissions do    
    desc "Give editor permissions"
    task :give, [:user] => :environment do |task, args|
        begin
            user = User.find_by_email(args.user)
            user.editor = true
            user.save
            print user.name + " given editor permissions.\n"
        rescue
            print "User with email " + args.user + " doesn't exist!\n"
        end
    end

    desc "Revoke editor permissions"
    task :revoke, [:user] => :environment do |task, args|
        begin
            user = User.find_by_email(args.user)
            user.editor = false
            user.save
            print "Revoked editor permissions from " + user.name + ".\n"
        rescue
            print "User with email " + args.user + " doesn't exist!\n"
        end
    end
end
