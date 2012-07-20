# encoding: utf-8

module GlossariesHelper
  def to_index(name)
    clist = [
      { first: "ぁ", last: "ぉ", map: "あ" },
      { first: "あ", last: "お", map: "あ" },
      { first: "か", last: "こ", map: "か" },
      { first: "さ", last: "そ", map: "さ" },
      { first: "た", last: "と", map: "た" },
      { first: "な", last: "の", map: "な" },
      { first: "は", last: "ほ", map: "は" },
      { first: "ま", last: "も", map: "ま" },
      { first: "や", last: "よ", map: "や" },
      { first: "わ", last: "ん", map: "わ" },
      { first: "0", last: "9", map: "数" },
    ]
    
    first_character = name.slice(0, 1)
    first_character.upcase!
    first_character.tr!("ァ-ン", "ぁ-ん")
    if first_character.sub(/[0-9A-Zぁ-ん]/, "").size >= 1
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
  
  def to_id(first_character)
    if first_character.sub(/[A-Z]/, "").size == 0
      return first_character
    else
      map = {
        "あ" => "a", "か" => "ka", "さ" => "sa", "た" => "ta", "な" => "na",
        "は" => "ha", "ま" => "ma", "や" => "ya", "ら" => "ra", "わ" => "wa",
        "数" => "numeric", "他" => "others"
      }
      return "kana_" + map[first_character]
    end    
  end
end
