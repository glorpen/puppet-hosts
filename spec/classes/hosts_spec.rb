require 'spec_helper'

describe 'hosts' do
  context 'with defaults' do
    let(:params) { { 'enable_defaults' => true } }

    it { is_expected.to contain_concat('/etc/hosts') }
    it { is_expected.to contain_hosts__host('ip6-localhost') }
    it { is_expected.to contain_hosts__host('localhost') }
  end
  context 'without defaults' do
    let(:params) { { 'enable_defaults' => false } }

    it { is_expected.to contain_concat('/etc/hosts') }
    it { is_expected.not_to contain_hosts__host('localhost') }
    it { is_expected.not_to contain_hosts__host('ip6-localhost') }
  end
  context 'with additional hosts' do
    let(:params) {
      {
        'enable_defaults' => false,
        'hosts' => [
          {'ip': '192.168.0.1', 'aliases': ['alias1']},
          {'ip': '192.168.0.2', 'aliases': ['alias2']}
        ]
      }
    }

    it { is_expected.to have_hosts__host_resource_count(2) }

    it 'additional hosts are defined' do
      items = catalogue.resources.select do |res|
        res.type == 'Hosts::Host'
      end

      expect(items[0][:ip]).to eq('192.168.0.1')
      expect(items[1][:ip]).to eq('192.168.0.2')
    end
  end
end
