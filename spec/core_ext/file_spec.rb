require 'rails_helper'

RSpec.describe File do
  let( :binary_path ) { ::Rails.root.join('client','src','favicon.ico').to_s }
  let( :plaintext_path ) { ::Rails.root.join('client','src','index.html').to_s }
  let( :empty_file ) { Tempfile.new('empty') }

  context 'binary?' do
    it 'should return false for an empty file' do
      begin
        empty_file.close
        expect( File.exist? empty_file.path ).to be true
        expect( File.binary? empty_file.path ).to be false
      ensure
        empty_file.unlink
      end
    end

    it 'should return true for a binary file' do
      expect( File.exist? binary_path ).to be true
      expect( File.binary? binary_path ).to be true
    end

    it 'should return false for a text file' do
      expect( File.exist? plaintext_path ).to be true
      expect( File.binary? plaintext_path ).to be false
    end
  end
end
