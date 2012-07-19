# encoding: utf-8

module GlossariesHelper
  def to_index(name)
    clist = [
      { first: "ぁ", last: "ぉ", map: "あ〜お" },
      { first: "あ", last: "お", map: "あ〜お" },
      { first: "か", last: "こ", map: "か〜こ" },
      { first: "さ", last: "そ", map: "さ〜そ" },
      { first: "た", last: "と", map: "た〜と" },
      { first: "な", last: "の", map: "な〜の" },
      { first: "は", last: "ほ", map: "は〜ほ" },
      { first: "ま", last: "も", map: "ま〜も" },
      { first: "や", last: "よ", map: "や〜よ" },
      { first: "わ", last: "ん", map: "わ〜ん" },
    ]
    
    first_character = name.slice(0, 1)
    first_character.upcase!
    first_character.tr!("ァ-ン", "ぁ-ん")
    if first_character.sub(/[A-Zぁ-ん]/, "").size >= 1
      return "他"
    end
    
    clist.each do |item|
      first_character.tr!(item[:first] + "-" + item[:last], item[:map].slice(0, 1))
    end
    
    clist.each_with_index do |item,i|
      if i >= 1
        first_character.sub!(item[:map].slice(0, 1), item[:map])
      end
    end
    
    first_character
  end
end
