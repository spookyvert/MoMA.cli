
require 'pry'
require_relative '../config/environment'
require 'tty-prompt'
@prompt = TTY::Prompt.new

######### Start Piece Lookup Helper Methods #########
def find_piece(query)
  Piece.all.find do |piece|
    piece.title.include? query

  end
end

# gallery formatter
def gf(artist,title,date,desc)
  puts """
  ----------------------------------------
       artist
          #{artist}
       title
          #{title}
       created
          #{date}
       desc
          #{desc}
  ----------------------------------------
    """
end

def exit
  @prompt.select('options') do |menu|
    menu.choice 'home', experience
  end
  system "clear" or system "cls"
end
############# Welcome #############

def welcome

  puts """
  ________________________________________________
  |                                              |
  |                                              |
  |                                              |
  |                                              |
  |                                              |
  |                                              |
  |                                              |
  |                                              |
  |                                              |
  |                              𝐰𝐞𝐥𝐜𝐨𝐦𝐞         |
  |                            𝐌𝐨𝐌𝐀.cli          |
  ________________________________________________
  """

  # @prompt.select("begin, ") do |menu|
  #   menu.choice name: 'new visitor', value: get_visitor_name
  #   menu.choice name: 'returning', value: 2
  # end

  answer = @prompt.select("begin, ", ["new visitor", "returning"])

  case answer
  when "new visitor"
    get_visitor_name
  when "returning"
    1
  end

  system "clear" or system "cls"
end

def favor
  @user.love(fp)
end


def get_visitor_name
  puts """

  hello! welcome to The Museum of Modern Art
  """

  tmp_name = @prompt.ask('What is your name?', default: ENV['USER'])

  @user = User.create(name: tmp_name)

  tmp_res = @prompt.yes?("""
     Hey #{tmp_name}!
     if you don\'t mind me asking..., are you looking on purchasing the rights to any pieces?""")
  if tmp_res == true
    @user.update(rich: true)
    puts "thank you!"
    experience
    binding.pry
  elsif tmp_res == false
    @user.update(rich: false)
    puts "thank you!"
    experience
  else
    "pardon? I don't understand your response."
    tmp_res
  end

end
def experience

  """
  welcome to MoMA!

  you have the option to, find a specific piece, show all pieces, visit the gallery, or purchase the rights to a Artwork
  """

  answer = @prompt.select("options, ", ['locate piece', 'all pieces', 'visit gallery','your favorites' ])

  case answer
  when 'locate piece'
    locate_screen
  when 'all pieces'
    allpieces
  when 'visit gallery'
    gallery
  when 'your favorites'
    favs
  end


end
def locate_screen
  tmp_query = @prompt.ask('please enter the title of the piece you\'re looking for?')
  tmp = find_piece(tmp_query)
  fgp(tmp)

end

#found gallery piece, formats it
def fgp(piece)
  gf(piece.artist,piece.title,piece.date,piece.desc)

  exit
end

def allpieces
  tmp = Piece.all.map do |piece|
    piece.title
  end
  "All of the artworks currently displayed."
  tmp.each do |piece|
    puts
    """
    #{piece}
     """
  end

  exit

end

def favs
  tmp_f = Favorite.where(user_id: @user.id)
  tmp_ps = tmp_f.map do |favorites|
    favorites.piece_id
  end.uniq

  piece = tmp_ps.map do |piece|
    tmp_finder = Piece.find(piece)
    tmp_finder.title
  end
  piece.each do |piece|
    tmp = find_piece(piece)
    gallery_piece(tmp.artist,tmp.title,tmp.date,tmp.desc)
  end

  exit

end



###############

def highest_rating
  run = Favorite.all.map do |fav|
    i = fav.piece_id
    p = Piece.find(i)
    p.title
  end
  v = run.sort_by { |n|
    run.count(n)
  }
  @rating = v.uniq.reverse.last(3)

  @rating.each do |piece|
    p = find_piece(piece)
    gallery_piece(p.artist,p.title,p.date,p.desc)
  end
end

def top
  highest_rating
  exit
end
###################




def gallery_locater(query)

  # tmp_query = @prompt.ask('please enter the title of the piece you\'re looking for?')
  tmp = query.title
  fp = find_piece(tmp) #found piece
  gf(fp.artist,fp.title,fp.date, fp.desc)


  answer = @prompt.select("options, ", ['visit gallery', 'find another piece', 'top 3 pieces','favorite this piece' ])

  case answer
  when 'visit gallery'
    gallery
  when 'find another piece'
    locate_screen
  when 'top 3 pieces'
    top
  when 'favorite this piece'
    favor
  end


end


def gallery


  piece = Piece.all.select do |piece|
    piece.title
    piece.artist
  end
  @gp = piece.sample(3)


  puts """
                                     ___---___
                             ___---___---___---___
                       ___---___---    *    ---___---___
                 ___---___---    o/ 0_/  @  o ^   ---___---___
           ___---___--- @  i_e J-U /|  -+D O|-| (o) /   ---___---___
     ___---___---    __/|  //*  /|  |8  /8  |*|  |_  __--oj   ---___---___
__---___---_________________________________________________________---___---__
===============================================================================
 ||||                          MoMA CLI, Gallery                          ||||
 |---------------------------------------------------------------------------|
 |___-----___-----___-----___-----___-----___-----___-----___-----___-----___|
 / _ *===/ _ *   / _ *===/ _ *   / _ *===/ _ *   / _ *===/ _ *   / _ *===/ _ *
( (.* oOo /.) ) 8( (. oOo /.) ) ( (.* oOo /.) ) ( (.* oOo /.) ) ( (.* oOo /.) )
 *__/=====*__/   *__/=====*__/   *__/=====*__/   *__/=====*__/   *__/=====8__/
    |||||||                            1                            |||||||
    |||||||                         -------                         |||||||
    |||||||                       |    .    |                       |||||||
    |||||||                       |    ;    |                       |||||||
    |||||||                       |- --+- - |                       |||||||
    |||||||                       |    !    |                       |||||||
    |||||||                       |    .    |                       |||||||
    |||||||                         -------                         |||||||
    #{@gp[0].artist}
    #{@gp[0].title}
    |||||||                                                         |||||||
    |||||||                                                         |||||||
    |||||||                            2                            |||||||
    |||||||                         -------                         |||||||
    |||||||                       |    ^    |                       |||||||
    |||||||                       | _(   )_ |                       |||||||
    |||||||                       |( `* /' )|                       |||||||
    |||||||                       |  _)^(_  |                       |||||||
    |||||||                       |    V    |                       |||||||
    |||||||                         -------                         |||||||
    #{@gp[1].artist}
    #{@gp[1].title}
    |||||||                                                         |||||||
    |||||||                                                         |||||||
    |||||||                            3                            |||||||
    |||||||                         -------                         |||||||
    |||||||                       |   ___   |                       |||||||
    |||||||                       |  / * *  |                       |||||||
    |||||||                       | / /_*_* |                       |||||||
    |||||||                       | */____/ |                       |||||||
    |||||||                       |         |                       |||||||
    |||||||                         -------                         |||||||
    #{@gp[2].artist}
    #{@gp[2].title}
    |||||||                                                         |||||||
    |||||||                                                         |||||||
    |||||||                                                         |||||||
    (oOoOo)                                                         (oOoOo)
    J%%%%%L         J%%%%%L         J%%%%%L         J%%%%%L         J%%%%%L
   ZZZZZZZZZ       ZZZZZZZZZ       ZZZZZZZZZ       ZZZZZZZZZ       ZZZZZZZZZ
  ===========================================================================
__|_________________________________________________________________________|__
_|___________________________________________________________________________|_
|_____________________________________________________________________________|
_______________________________________________________________________________
"""


  answer = @prompt.select("show more info ", ['1', '2', '3', 'exit' ])

  case answer
  when '1'
    locate_piece(@gp[0])
  when '2'
    locate_piece(@gp[1])
  when '3'
    locate_piece(@gp[2])
  when 'exit'
    experience
  end


end

# def banksy
# # art = Piece.all
# # #art.destroy_all
# # Piece.create(title: "Balloon Girl", desc: "the urge to destroy is also a creative urge", artist: "banksy")
#
# puts """
# ᴡʜᴀᴛ ᴅɪᴅ ʏᴏᴜ ᴊᴜꜱᴛ ᴅᴏ!
# ꜱᴇᴄᴜʀɪᴛʏ! ꜱᴇᴄᴜʀɪᴛʏ!
# ᴡʜᴀᴛ ᴅɪᴅ ʏᴏᴜ ᴅᴏ !
#  ᴛʜᴇ ɢᴀʟʟᴇʀʏ!!!
# """
# puts " [1] gallery "
#
# r = gets.chomp
# system "clear" or system "cls"
#
# case r
# when "1"
#   gallery
# else
#   gallery
# end
