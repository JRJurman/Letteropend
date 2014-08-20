require 'spec_helper'

describe Letteropend::Film do
  let(:film) { Letteropend::Film.new 'chopping-mall' }

  describe '.new' do
    it('defines @title') { expect(film.title).to eq 'Chopping Mall' }

    it('defines @url') { expect(film.url).to eq '/film/chopping-mall/' }
  end

  describe '#runtime' do
    it('returns the running length') { expect(film.runtime).to be 77 }
  end

  describe '#tagline' do
    it('returns the tagline') { expect(film.tagline).to eq 'Half-off is just the beginning!' }
  end

  describe '#overview' do
    it('returns the overview') { expect(film.overview).to eq 'Eight teenagers are trapped after hours in a high tech shopping mall and pursued by three murderous security robots out of control.' }
  end

  describe '#pull_data' do
    context 'without callbacks' do
      it('defines @runtime') { expect(film.runtime).to be_truthy }

      it('defines @tagline') { expect(film.tagline).to be_truthy }

      it('defines @overview') { expect(film.overview).to be_truthy }
    end

    context 'with callbacks' do
      it
    end
  end

  describe '#==' do
    let(:same_film) { Letteropend::Film.new 'Chopping Mall', '/film/chopping-mall/' }
    let(:different_film) { Letteropend::Film.new 'Paul Blart: Mall Cop', '/film/paul-blart-mall-cop/' }
    let(:different_name_film) { Letteropend::Film.new 'Paul Blart: Mall Cop', '/film/chopping-mall/' }
    let(:different_url_film) { Letteropend::Film.new 'Chopping Mall', '/film/paul-blart-mall-cop/' }

    context 'with the same film' do
      it { expect(film == same_film).to be true }
    end

    context 'with a different film' do
      it { expect(film == different_film).to be false }
    end

    context 'with a film with a different name' do
      it { expect(film == different_name_film).to be false }
    end

    context 'with a film with a different url' do
      it { expect(film == different_url_film).to be false }
    end
  end
end
