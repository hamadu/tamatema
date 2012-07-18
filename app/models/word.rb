# encoding: utf-8

class Word < ActiveRecord::Base
  attr_accessible :description, :name, :read
  
  belongs_to :glossary
  validates :name, presence: true, length: { maximum: 128 }
  validates :read, length: { maximum: 128 }
  validates :description, length: { maximum: 1023 }
  validates :glossary_id, presence: true
  
  before_save :generate_read
  
  def description_html
    html = "";
    description.split("\n").each do |line|
      line = CGI.escapeHTML(line)
      line.gsub!(/{(\S*)}/, "→<a href='#\\1'>\\1</a>")
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
  
  private
    def generate_read
      if self.read == nil || self.read == ''
        self.read = self.name
      end
    end
end
