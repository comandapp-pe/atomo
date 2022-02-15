class Locution < ApplicationRecord
    before_validation :sync, on: :create
    def sync
        return errors.add(:vimeo_url, 'no puede estar en blanco') if vimeo_url.blank?
    
        return errors.add(:vimeo_url, "ya existe en otro producto") if Product.exists?(vimeo_url: vimeo_url)
    
        sync_vimeo
    
        return if errors.any?
      end

      def sync_vimeo
        response = Faraday.get("https://vimeo.com/api/oembed.json?url=#{self.vimeo_url}")
    
        return errors.add(:vimeo_url, 'no es una url válida') if response.status != 200
    
        body = JSON.parse(response.body).transform_keys(&:to_sym)
    
        # TODO: Add a failsafe in case Vimeo's API doesn't return what's expected
    
        self.name = body[:title]
    
        html = Nokogiri::HTML(body[:html])
        iframe = html.at('iframe')
        self.preview_html = iframe.to_s
    
        self.description = body[:description].blank? ? 'Descripción por defecto.' : body[:description]
        self.thumbnail_url = body[:thumbnail_url]
        self.thumbnail_url_with_play_button = body[:thumbnail_url_with_play_button]
        self.published = true
      end
end

