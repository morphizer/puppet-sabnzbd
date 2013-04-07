require 'spec_helper'

describe 'sabnzbd', :type => 'class' do

  context "On Debian OS" do
    let :facts do
      {
        :operatingsystem => 'Debian'
      }
    end

    it {
      should contain_package('unrar-free')
    }
  end

  context "On Ubuntu OS" do
     let :facts do
       {
         :operatingsystem => 'Ubuntu'
       }
     end

     it {
       should contain_package('unrar')
     }
  end

  context "On any system with a different user specified" do
    let :params do
      {
        :user => 'mediauser'
      }
    end

    it {
      should contain_user('mediauser')
    }
  end
end
