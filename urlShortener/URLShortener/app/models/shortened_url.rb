# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'SecureRandom'

class ShortenedUrl < ApplicationRecord
    validates :short_url, presence: true, uniqueness: true
    validates :long_url, presence: true
    validates :user_id, presence: true
    # belongs_to :user 

    belongs_to(:submitter,
        class_name: :User,
        primary_key: :id,
        foreign_key: :user_id
    )

    has_many(:visits,
        class_name: :Visit,
        primary_key: :id,
        foreign_key: :short_url_id
    )

    def self.random_code
        code = SecureRandom.urlsafe_base64
        if ShortenedUrl.exists?(:short_url => code)
            return ShortenedUrl.random_code
        else
            return code
        end
    end

    def self.create_short_url(user,long_u)
        code = self.random_code
        info = {
            :user_id => user.id,
            :short_url => code,
            :long_url => long_u
        }
        ShortenedUrl.create(info)
    end

    def num_clicks
        self.visits.count
    end

    def num_uniques
        hash = Hash.new(0)
        self.visits.each do |v|
            # p Time.now - self.created_at
            hash[v.user_id] += 1
        end
        return hash.keys.length
    end

    def num_recent_uniques
        hash = Hash.new(0)
        
        self.visits.each do |v|
            hash[v.user_id] += 1 if Time.now.utc-v.created_at < 600
        end
        return hash.keys.length
    end

end
