class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

    # Define the Entry object
  class Entry
    def initialize(lobbyist, principal, employed_on, issue_description, issue_status)
      @lobbyist = lobbyist
      @principal = principal
      @employed_on = employed_on
      @issue_description = issue_description
      @issue_status = issue_status
    end
    attr_reader :lobbyist
    attr_reader :principal
    attr_reader :employed_on
    attr_reader :issue_description
    attr_reader :issue_status
  end

  def scrape
    require 'open-uri'
    doc = Nokogiri::HTML(open("https://www8.miamidade.gov/Apps/COB/LobbyistOnline/Views/Queries/Registration_ByPeriod_List.aspx?startdate=01%2f01%2f2017&enddate=04%2f08%2f2017"))

    entries = doc.css('#ctl00_mainContentPlaceHolder_gvLobbyistRegList>tr')
    @entriesArray = []
    entries.each do |entry|
      lobbyist = entry.css('td[1]').text
      principal = entry.css('td[2]').text
      employed_on = entry.css('td[3]').text
      issue_description = entry.css('td[4]').text
      issue_status = entry.css('td[5]').text
      @entriesArray << Entry.new(lobbyist, principal, employed_on, issue_description, issue_status)
    end

    render template: 'scrape'
  end
end
