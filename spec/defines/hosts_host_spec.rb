require 'spec_helper'

describe 'hosts::host' do
  def host_entry(ip, aliases)
    padding = (ip.length / 12.0).ceil * 12 + 1
    ("%-#{padding}s" % ip) + [aliases].flatten.join(' ')
  end

  let(:title) { 'example-host' }
  let(:facts) { {} }

  describe 'on linux' do
    context 'with no alias' do
      let(:params) { { 'ip' => '192.168.0.1' } }

      it { is_expected.to contain_concat__fragment('hosts:host:example-host').with_content(host_entry('192.168.0.1', 'example-host')) }
    end

    context 'with alias as string' do
      let(:params) do
        {
          'ip' => '192.168.0.1',
          'aliases' => 'localalias',
        }
      end

      it { is_expected.to contain_concat__fragment('hosts:host:example-host').with_content(host_entry('192.168.0.1', 'localalias')) }
    end

    context 'with alias as list' do
      let(:params) do
        {
          'ip' => '192.168.0.1',
          'aliases' => ['a0', 'a1'],
        }
      end

      it { is_expected.to contain_concat__fragment('hosts:host:example-host').with_content(host_entry('192.168.0.1', ['a0', 'a1'])) }
    end

    context 'with long padded ip' do
      let(:params) do
        {
          'ip' => '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
          'aliases' => ['long-ip'],
        }
      end

      it { is_expected.to contain_concat__fragment('hosts:host:example-host').with_content(host_entry('2001:0db8:85a3:0000:0000:8a2e:0370:7334', ['long-ip'])) }
    end
  end

  describe 'on windows' do
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

    context 'with multiple aliases' do
      let(:params) do
        {
          'ip' => '192.168.0.1',
          'aliases' => ['a0', 'a1'],
        }
      end

      it { is_expected.to contain_concat__fragment('hosts:host:example-host:a0').with_content(host_entry('192.168.0.1', ['a0'])) }
      it { is_expected.to contain_concat__fragment('hosts:host:example-host:a1').with_content(host_entry('192.168.0.1', ['a1'])) }
    end

    context 'with no alias' do
      let(:params) { { 'ip' => '192.168.0.1' } }

      it { is_expected.to contain_concat__fragment('hosts:host:example-host:example-host').with_content(host_entry('192.168.0.1', 'example-host')) }
    end
  end
end
