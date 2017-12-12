require 'spec_helper'

describe 'software::idesdk::pdk' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with defaults' do
        if facts[:operatingsystem] == 'Ubuntu'
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/tmp/pdk.deb') }
          it { is_expected.to contain_package('pdk') }
        else
          it { is_expected.to compile.and_raise_error(/is not supported on /) }
        end
      end
    end
  end
end
