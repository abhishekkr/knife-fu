module ABK_KnifePlugins
  class LabRoleRename < Chef::Knife

    banner "knife lab role rename CURRENT_ROLE_NAME NEW_ROLE_NAME"
  
    def run 
      err_ "Wrong Syntax.", "Correct Syntax is", "$ knife lab role rename CURRENT_ROLE_NAME NEW_ROLE_NAME" if ARGV.length != 5
      puts "Renaming Role",ARGV[3] + " to " + ARGV[4]
      current_role_name=ARGV[3]
      new_role_name=ARGV[4]
      check_roles_ current_role_name, new_role_name
      rename_role_ current_role_name, new_role_name
    end

    def check_roles_ (current, new)
      role_status=%x{knife role show #{current}; echo $?}.split("\n")[-1].to_i
      err_ "CURRENT_ROLE_NAME: #{current} :: Doesn't Exist" unless role_status == 0
      role_status=%x{knife role show #{new}; echo $?}.split("\n")[-1].to_i
      err_ "NEW_ROLE_NAME: #{new} :: Already Exists" if role_status == 0
    end

    def rename_role_ (current, new)
      cmd_status=%x{knife role show #{current} -Fj > /tmp/#{new}.json; echo $?}.split("\n")[-1].to_i
      err_ "Cannot write #{current} role's JSON config to /tmp/#{new}.json" unless cmd_status==0
      cmd_status=%x{sed -i 's/"name" *: *"#{current}" *,/"name" : "#{new}" ,/g' /tmp/#{new}.json; echo $?}.split("\n")[-1].to_i
      err_ "Cannot edit current role's name property in /tmp/#{new}.json" unless cmd_status==0
      cmd_status=%x{knife role from file /tmp/#{new}.json; echo $?}.split("\n")[-1].to_i
      err_ "Cannot import role from file /tmp/#{new}.json" unless cmd_status==0
      cmd_status=%x{rm -f /tmp/#{new}.json; echo $?}.split("\n")[-1].to_i
      err_ "Cannot delete /tmp/#{new}.json" unless cmd_status==0
      cmd_status=%x{knife role delete #{current} -y; echo $?}.split("\n")[-1].to_i
      err_ "Cannot delete role #{current}" unless cmd_status==0
    end

    def err_ (err_msg)
        puts "Exiting.....\n", "Error: " + err_msg
        exit 1
    end

  end
end
