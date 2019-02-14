
require 'pry'
require_relative '../config/environment'
require 'tty-prompt'
@prompt = TTY::Prompt.new

######### Start Piece Lookup Helper Methods #########
def find_piece(query)
  if query == 'banksy'
    banksy
  else
    Piece.all.find do |piece|
      piece.title.include? query
    end
  end

end


# gallery formatter
def gf(artist,title,date,desc)
  puts """
  _________________________▂▃▅▇█▓▒░۩۞۩ ۩۞۩░▒▓█▇▅▃▂________________________
   |____________________________________________________________________|
   |                             piece found!                           |
   |                                                                    |

       #{artist}
   |                                                                    |
       #{title}
   |                                                                    |
       #{date}
   |                                                                    |
       #{desc}
   |                                                                    |
   |                                                                    |
   |____________________________________________________________________|
   ¸,ø¤º°`°º¤ø,¸¸,ø¤º°°º¤ø,¸¸,ø¤º°`°º¤ø,¸ ¸,ø¤º°`°º¤ø,¸¸,ø¤º°¸,ø¤º°`°º¤ø,¸
    """


end

def exit
  answer = @prompt.select("options, ", ['locate piece', 'all pieces', 'visit gallery','your favorites', 'vault' ])

  case answer
  when 'locate piece'
    system "clear" or system "cls"
    locate_screen
  when 'all pieces'
    system "clear" or system "cls"
    allpieces
  when 'visit gallery'
    system "clear" or system "cls"
    gallery
  when 'your favorites'
    system "clear" or system "cls"
    favs
  when 'vault'
    system "clear" or system "cls"
    if @user.rich == true
      owned_pieces
    else
      puts "you DO NOT have access to this area"
    end
  end


  system "clear" or system "cls"
end
############# Welcome #############

def welcome
  # start "../sound/music.mp3"
  puts """

  _________________________▂▃▅▇█▓▒░۩۞۩ ۩۞۩░▒▓█▇▅▃▂________________________
   |                                                                    |
   |                                                                    |
   |                                                                    |
   |                                                                    |
   |                                                                    |
   |                                                                    |
   |                                                                    |
   |                                                                    |
   |                                                                    |
   |                                                                    |
   |                                                                    |
   |                                                      welcome to    |
   |                                                       𝙼𝚘𝙼𝙰.cli     |
   |____________________________________________________________________|
   ¸,ø¤º°`°º¤ø,¸¸,ø¤º°°º¤ø,¸¸,ø¤º°`°º¤ø,¸ ¸,ø¤º°`°º¤ø,¸¸,ø¤º°¸,ø¤º°`°º¤ø,¸
  """


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
  """
    ¸,ø¤º°`°º¤ø,¸¸,ø¤º°°º¤ø,¸¸,ø¤º°`°º¤ø,¸ ¸,ø¤º°`°º¤ø,¸¸,ø¤º°¸,ø¤º°`°º¤ø,¸

      |                                                                    |
      |          Added to your favorites!                                  |
      |                                                                    |

      ¸,ø¤º°`°º¤ø,¸¸,ø¤º°°º¤ø,¸¸,ø¤º°`°º¤ø,¸ ¸,ø¤º°`°º¤ø,¸¸,ø¤º°¸,ø¤º°`°º¤ø,¸
     """
  @user.love(@fp)
  exit
end


def get_visitor_name
  puts """
  ¸,ø¤º°`°º¤ø,¸¸,ø¤º°°º¤ø,¸¸,ø¤º°`°º¤ø,¸ ¸,ø¤º°`°º¤ø,¸¸,ø¤º°¸,ø¤º°`°º¤ø,¸

    |                                                                    |
    |          to get started, please tell me your name  :)              |
    |                                                                    |

    ¸,ø¤º°`°º¤ø,¸¸,ø¤º°°º¤ø,¸¸,ø¤º°`°º¤ø,¸ ¸,ø¤º°`°º¤ø,¸¸,ø¤º°¸,ø¤º°`°º¤ø,¸
  """

  tmp_name = @prompt.ask('What is your name?', default: ENV['USER'])

  @user = User.create(name: tmp_name)
  system "clear" or system "cls"
  tmp_res = @prompt.yes?("""
    ¸,ø¤º°`°º¤ø,¸¸,ø¤º°°º¤ø,¸¸,ø¤º°`°º¤ø,¸ ¸,ø¤º°`°º¤ø,¸¸,ø¤º°¸,ø¤º°`°º¤ø,¸

      |                                                                    |
      |          If you don't mind me asking,                              |
      |           are you looking to purchase today?                       |

      ¸,ø¤º°`°º¤ø,¸¸,ø¤º°°º¤ø,¸¸,ø¤º°`°º¤ø,¸ ¸,ø¤º°`°º¤ø,¸¸,ø¤º°¸,ø¤º°`°º¤ø,¸
     """)

  case tmp_res
  when true
    @user.update(rich: true)
    system "clear" or system "cls"
    experience
  when false
    @user.update(rich: false)
    system "clear" or system "cls"
    experience
  else
    @user.update(rich: false)
    system "clear" or system "cls"
    experience
  end

end
def experience

  puts """
 _________________________▂▃▅▇█▓▒░۩۞۩ ۩۞۩░▒▓█▇▅▃▂________________________
  |____________________________________________________________________|
  |                        welcome to MoMA!                            |
  |                                                                    |
  |   you have the option to, find a specific piece, show all pieces,  |
  |        visit the gallery, or purchase the rights to a Artwork      |
  |____________________________________________________________________|
  ¸,ø¤º°`°º¤ø,¸¸,ø¤º°°º¤ø,¸¸,ø¤º°`°º¤ø,¸ ¸,ø¤º°`°º¤ø,¸¸,ø¤º°¸,ø¤º°`°º¤ø,¸
  """

  answer = @prompt.select("options, ", ['locate piece', 'all pieces', 'visit gallery','your favorites', 'vault' ])

  case answer
  when 'locate piece'
    locate_screen
  when 'all pieces'
    allpieces
  when 'visit gallery'
    gallery
  when 'your favorites'
    favs
  when 'vault'
    if @user.rich == true
      owned_pieces
    else
      puts "you DO NOT have access to this area"
    end
  end


end

def locate_screen
  tmp_query = @prompt.ask("""
      ¸,ø¤º°`°º¤ø,¸¸,ø¤º°°º¤ø,¸¸,ø¤º°`°º¤ø,¸ ¸,ø¤º°`°º¤ø,¸¸,ø¤º°¸,ø¤º°`°º¤ø,¸
      |                           search...                                |
      |                                                                    |
      |       please enter the title of the piece you\'re looking for      |
      |                                                                    |
      |____________________________________________________________________|

  """)
  tmp = find_piece(tmp_query)

  system "clear" or system "cls"
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

  puts """
  _________________________▂▃▅▇█▓▒░۩۞۩ ۩۞۩░▒▓█▇▅▃▂________________________
   |____________________________________________________________________|
   |                                                                    |
   |                                                                    |
   |        * All of the artworks currently displayed                   |
   |                                                                    |
   |                                                                    |"""
  #{print}
  tmp.each do |piece|
    puts "          - #{piece}"
  end


  puts """
   |                                                                    |
   |                                                                    |
   |                                                                    |
   |                                                                    |
   |____________________________________________________________________|
   ¸,ø¤º°`°º¤ø,¸¸,ø¤º°°º¤ø,¸¸,ø¤º°`°º¤ø,¸ ¸,ø¤º��`°º¤ø,¸¸,ø¤º°¸,ø¤º°`°º¤ø,¸
  """


  exit

end

def favs
  tmp_f = Favorite.where(user_id: @user.id)
  tmp_ps = tmp_f.map do |favorites|
    favorites.piece_id
  end.uniq

  piece = tmp_ps.map do |x|
    tmp_finder = Piece.find(x)
    tmp_finder.title
  end
  piece.each do |piece|
    tmp = find_piece(piece)
    gf(tmp.artist,tmp.title,tmp.date,tmp.desc)
  end

  piece.each do |p|
    find_piece(p)
  end
  piece.each do |p|
    p[0]
  end
  exit

end

def owned_pieces
  tmp_p = Piece.where(user_id: @user.id)
  op = tmp_p.map do |piece|
    piece.title

  end

  op.each do |piece| #owned piece

    tmp = find_piece(piece)
    gf(tmp.artist,tmp.title,tmp.date,tmp.desc)
  end



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
    gf(p.artist,p.title,p.date,p.desc)
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
  @fp = find_piece(tmp) #found piece
  gf(@fp.artist,@fp.title,@fp.date, @fp.desc)


  answer = @prompt.select("options, ", ['visit gallery', 'find another piece', 'top 3 pieces','favorite this piece', 'claim piece!' ])

  case answer
  when 'visit gallery'
    system "clear" or system "cls"
    gallery
  when 'find another piece'
    system "clear" or system "cls"
    locate_screen
  when 'top 3 pieces'
    system "clear" or system "cls"
    top
  when 'favorite this piece'
    system "clear" or system "cls"
    favor
  when 'claim piece!'
    if @user.rich == true && @fp.user_id == nil
      claim
      system "clear" or system "cls"
      puts """

      Thank you for claiming the rights to this piece!

       """
      exit
    elsif @fp.user_id == @user.id
      puts """

      You already own this piece!

      """

      exit
    else
      puts """

      you are not eligible to claim this piece

       """
      exit
    end

  end


end
def claim
  @fp.update(user_id: @user.id)
end

def gallery


  piece = Piece.all.select do |piece|
    piece.title
    piece.artist
    piece.desc
  end

  @banks = puts """
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
    |||||||                                                         |||||||
    |||||||                                                         |||||||
    |||||||                                                         |||||||
    |||||||                         -------                         |||||||
    |||||||                       |    .    |                       |||||||
    |||||||                       |    ;    |                       |||||||
    |||||||                       |- --+- - |                       |||||||
    |||||||                       |    !    |                       |||||||
    |||||||                       |    .    |                       |||||||
    |||||||                         -------                         |||||||
    |||||||                                                         |||||||
    |||||||                                                         |||||||
    |||||||                            1                            |||||||
    |||||||                         -------                         |||||||
    |||||||                       |    ^    |                       |||||||
    |||||||                       | _(   )_ |                       |||||||
    |||||||                       |( `* /' )|                       |||||||
    |||||||                       |  _)^(_  |                       |||||||
    |||||||                       |    V    |                       |||||||
    |||||||                         -------                         |||||||
                               #{piece[0].artist}
                               #{piece[0].title}
                               #{piece[0].desc}
    |||||||                                                         |||||||
    |||||||                                                         |||||||
    |||||||                                                         |||||||
    |||||||                         -------                         |||||||
    |||||||                       |   ___   |                       |||||||
    |||||||                       |  / * *  |                       |||||||
    |||||||                       | / /_*_* |                       |||||||
    |||||||                       | */____/ |                       |||||||
    |||||||                       |         |                       |||||||
    |||||||                         -------                         |||||||
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


  def regular_res
    answer = @prompt.select("show more info ", ['1', '2', '3', 'exit' ])

    case answer
    when '1'
      system "clear" or system "cls"
      gallery_locater(@gp[0])
    when '2'
      system "clear" or system "cls"
      gallery_locater(@gp[1])
    when '3'
      system "clear" or system "cls"
      gallery_locater(@gp[2])
    when 'exit'
      system "clear" or system "cls"
      experience
    end
  end
  def banks_res
    answer = @prompt.select("options", ['exit' ])

    case answer
    when 'exit'
      system "clear" or system "cls"
      experience
    end
  end


  if piece.length == 1
    @banks
    banks_res
  else
    @gp = piece.sample(3)
    regular = puts """
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
        |||||||                                                         |||||||
        |||||||                                                         |||||||
        |||||||                                                         |||||||
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
    regular_res
  end





end




def banksy
  art = Piece.all
  art.destroy_all
  Piece.create(title: "Balloon Girl", desc: "the urge to destroy is also a creative urge", artist: "banksy")

  puts """
        ᴡʜᴀᴛ ᴅɪᴅ ʏᴏᴜ ᴊᴜꜱᴛ ᴅᴏ!
        ꜱᴇᴄᴜʀɪᴛʏ! ꜱᴇᴄᴜʀɪᴛʏ!
        ᴡʜᴀᴛ ᴅɪᴅ ʏᴏᴜ ᴅᴏ !
         ᴛʜᴇ ɢᴀʟʟᴇʀʏ!!!
 """

  puts " [1] gallery "

  r = gets.chomp
  system "clear" or system "cls"

  case r
  when "1"
    gallery
  else
    gallery
  end

end
