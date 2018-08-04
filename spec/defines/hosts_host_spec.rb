require 'spec_helper'

describe 'hosts::host' do
  let(:title) { 'example-host' }

  def host_entry(ip, aliases)
    ('%-24s' % ip) + [aliases].flatten.join(' ')
  end

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
end
