class PartnerController < ApplicationController

	def create
		@partner = Partner.new(params[:partner])
		@partner.save
		redirect_to players_path
	end

	def new
		@partner = Partner.new
	end

	def update
		@partner = Partner.find(params[:id])
		@partner.update(params[:player])
		redirect_to players_path
	end

end
