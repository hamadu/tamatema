# encoding: utf-8

def sign_in(user)
  visit login_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "ログイン"
  cookies[:remember_token] = user.remember_token
end

def full_title(page_title)
  base_title = "用語集メーカー"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

