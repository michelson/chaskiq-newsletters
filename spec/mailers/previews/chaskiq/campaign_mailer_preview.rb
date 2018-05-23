module Chaskiq
  # Preview all emails at http://localhost:3000/rails/mailers/campaign_mailer
  class CampaignMailerPreview < ActionMailer::Preview

    def test(campaign)
      binding.pry
      @campaign = Chaskiq::Campaign.find(13)

      Chaskiq::CampaignMailer.with(@campaign).welcome_email
    end

  end
end
