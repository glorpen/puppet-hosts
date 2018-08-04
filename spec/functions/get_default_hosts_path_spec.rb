require 'spec_helper'

describe 'hosts::get_default_hosts_path' do
  let(:facts) { {} }

  it { is_expected.not_to eq(nil) }

  describe 'on linux' do
    context 'with defaults' do
      it { is_expected.to run.and_return('/etc/hosts') }
    end
  end
  describe 'on windows' do
    context 'with modern facts' do
      let(:facts) do
        super().merge(
          os: {
            'family' => 'windows',
            'windows' => {
              'system32' => 'C:\Windows\system32',
            },
          },
        )
      end

      it { is_expected.to run.and_return('C:\Windows\system32\drivers\etc\hosts') }
    end
    context 'with legacy facts' do
      let(:facts) do
        super().merge(
          os: {
            'family' => 'windows',
          },
          system32: 'C:\Windows\system32',
        )
      end

      it { is_expected.to run.and_return('C:\Windows\system32\drivers\etc\hosts') }
    end
    context 'without known facts' do
      let(:facts) do
        super().merge(
          os: {
            'family' => 'windows',
          },
        )
      end

      it { is_expected.to run.and_raise_error(%r{.*No system32 fact found.*}) }
    end
  end
end
