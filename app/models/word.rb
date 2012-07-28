# encoding: utf-8

class Word < ActiveRecord::Base
  attr_accessible :description, :name, :read
  
  belongs_to :glossary
  has_many :word_stars
  
  validates :name, presence: true, length: { maximum: 128 }
  validates :read, length: { maximum: 128 }
  validates :description, length: { maximum: 1023 }
  validates :glossary_id, presence: true
  
  before_save :generate_read
  
  def star?(user)
    word_stars.find_by_user_id(user.id)
  end
  
  def star!(user)
    word_stars.create!(user_id: user.id)
  end
  
  def unstar!(user)
    word_stars.find_by_user_id(user.id).destroy
  end

  
  def description_html
    html = "";
    description.split("\n").each do |line|
      line = CGI.escapeHTML(line)
      
      line.gsub!(/{(\S*)}/) { "→<a href='#_" + Digest::MD5.hexdigest($1) + "'>#{$1}</a>" }
      line.gsub!(/\[(\S*?),(\S*?)\]/, "<a href='\\1' target='_blank'>\\2</a>")
      line.gsub!(/\[(\S*?)\]/, "<a href='\\1' target='_blank'>\\1</a>")

      html += line + "<br/>"
    end
    if html.size >= 5
      html.slice!(0, html.size - 5)
    else
      html
    end
  end
  
  def crypted_name
    Digest::MD5.hexdigest(name)
  end
  
  def read_in_sort
    read_in_sort = read.upcase
    read_in_sort.tr!("ァ-ン", "ぁ-ん")
    ret_value = ""
    replace_with = "ー"
    for i in 0..read_in_sort.length
      letter = read_in_sort[i..i]
      if letter == "ー"
        ret_value += replace_with
      else
        ret_value += letter
        if /[あかさたなはまやらわぁゎヵ]/ =~ letter
          replace_with = "あ"
        elsif /[いきしちにひみりゐぃ]/ =~ letter
          replace_with = "い"
        elsif /[うくすつぬふむゆるぅ]/ =~ letter
          replace_with = "う"
        elsif /[えけせてねへめれゑぇ]/ =~ letter
          replace_with = "え"
        elsif /[おこそとのほもよろを]/ =~ letter
          replace_with = "お"
        else
          replace_with = letter
        end
      end
    end
    ret_value
  end
  
  def read_in_glossary
    if name == read
      "-"
    else
      read
    end
  end
  
  private
    def generate_read
      if self.read == nil || self.read == ''
        self.read = self.name
      end
    end
end
