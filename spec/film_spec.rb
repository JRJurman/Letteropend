require 'spec_helper'

describe Letteropend::Film do
  let(:film) { Letteropend::Film.new 'chopping-mall' }

  describe '.new' do
    let(:expected_url) { 'http://letterboxd.com/film/chopping-mall/' }

    context('when given a slug') do
      let(:film) { Letteropend::Film.new 'chopping-mall' }

      it('defines @title') { expect(film.title).to eq 'Chopping Mall' }
      it('defines @slug') { expect(film.slug).to eq 'chopping-mall' }
      it('defines @url') { expect(film.url).to eq expected_url }
    end

    context('when given a path') do
      let(:film) { Letteropend::Film.new '/film/chopping-mall/' }

      it('defines @title') { expect(film.title).to eq 'Chopping Mall' }
      it('defines @slug') { expect(film.slug).to eq 'chopping-mall' }
      it('defines @url') { expect(film.url).to eq expected_url }
    end

    context('when given a URL without a protocol') do
      let(:film) { Letteropend::Film.new 'letterboxd.com/film/chopping-mall/' }

      it('defines @title') { expect(film.title).to eq 'Chopping Mall' }
      it('defines @slug') { expect(film.slug).to eq 'chopping-mall' }
      it('defines @url') { expect(film.url).to eq expected_url }
    end

    context('when given a full URL') do
      let(:film) { Letteropend::Film.new 'http://letterboxd.com/film/chopping-mall/' }

      it('defines @title') { expect(film.title).to eq 'Chopping Mall' }
      it('defines @slug') { expect(film.slug).to eq 'chopping-mall' }
      it('defines @url') { expect(film.url).to eq expected_url }
    end
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
    let(:chopping_mall) { Letteropend::Film.new 'chopping-mall' }
    let(:mall_cop) { Letteropend::Film.new 'paul-blart-mall-cop' }

    context 'with a Film with the same slug' do
      it { expect(film == chopping_mall).to be true }
    end

    context 'with a Film with a different slug' do
      it { expect(film == mall_cop).to be false }
    end
  end
end
