module ABK_KnifePlugins
  class LabChefVersions < Chef::Knife

    banner "knife lab chef versions"
  
    def run 
      chef=%x{gem list chef | grep chef}
      puts "Chef Gem Versions:",chef
    end

  end
end
