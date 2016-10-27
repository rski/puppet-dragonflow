#
# Unit tests for dragonflow::keystone::auth
#

require 'spec_helper'

describe 'dragonflow::keystone::auth' do
  shared_examples_for 'dragonflow-keystone-auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'dragonflow_password',
          :tenant   => 'foobar' }
      end

      it { is_expected.to contain_keystone_user('dragonflow').with(
        :ensure   => 'present',
        :password => 'dragonflow_password',
      ) }

      it { is_expected.to contain_keystone_user_role('dragonflow@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { is_expected.to contain_keystone_service('dragonflow::FIXME').with(
        :ensure      => 'present',
        :description => 'dragonflow FIXME Service'
      ) }

      it { is_expected.to contain_keystone_endpoint('RegionOne/dragonflow::FIXME').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:FIXME',
        :admin_url    => 'http://127.0.0.1:FIXME',
        :internal_url => 'http://127.0.0.1:FIXME',
      ) }
    end

    context 'when overriding URL parameters' do
      let :params do
        { :password     => 'dragonflow_password',
          :public_url   => 'https://10.10.10.10:80',
          :internal_url => 'http://10.10.10.11:81',
          :admin_url    => 'http://10.10.10.12:81', }
      end

      it { is_expected.to contain_keystone_endpoint('RegionOne/dragonflow::FIXME').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81',
      ) }
    end

    context 'when overriding auth name' do
      let :params do
        { :password => 'foo',
          :auth_name => 'dragonflowy' }
      end

      it { is_expected.to contain_keystone_user('dragonflowy') }
      it { is_expected.to contain_keystone_user_role('dragonflowy@services') }
      it { is_expected.to contain_keystone_service('dragonflow::FIXME') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/dragonflow::FIXME') }
    end

    context 'when overriding service name' do
      let :params do
        { :service_name => 'dragonflow_service',
          :auth_name    => 'dragonflow',
          :password     => 'dragonflow_password' }
      end

      it { is_expected.to contain_keystone_user('dragonflow') }
      it { is_expected.to contain_keystone_user_role('dragonflow@services') }
      it { is_expected.to contain_keystone_service('dragonflow_service::FIXME') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/dragonflow_service::FIXME') }
    end

    context 'when disabling user configuration' do

      let :params do
        {
          :password       => 'dragonflow_password',
          :configure_user => false
        }
      end

      it { is_expected.not_to contain_keystone_user('dragonflow') }
      it { is_expected.to contain_keystone_user_role('dragonflow@services') }
      it { is_expected.to contain_keystone_service('dragonflow::FIXME').with(
        :ensure      => 'present',
        :description => 'dragonflow FIXME Service'
      ) }

    end

    context 'when disabling user and user role configuration' do

      let :params do
        {
          :password            => 'dragonflow_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { is_expected.not_to contain_keystone_user('dragonflow') }
      it { is_expected.not_to contain_keystone_user_role('dragonflow@services') }
      it { is_expected.to contain_keystone_service('dragonflow::FIXME').with(
        :ensure      => 'present',
        :description => 'dragonflow FIXME Service'
      ) }

    end

    context 'when using ensure absent' do

      let :params do
        {
          :password => 'dragonflow_password',
          :ensure   => 'absent'
        }
      end

      it { is_expected.to contain_keystone__resource__service_identity('dragonflow').with_ensure('absent') }

    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'dragonflow-keystone-auth'
    end
  end
end
