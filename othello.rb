# coding utf-8

# ボードの表示
def show board
  # 横のヘッダ
  print "  "
  for i in 1..8
    print i
    print " "
  end
  puts

  # 行ごとに縦のヘッダと列を出力
  board.each_with_index {|x, y|
    print y + 1
    x.each {|a|
      print " "
      if(a == 0)
        print "-"
      elsif(a == 1)
        print "●"
      elsif(a == 2)
        print "○"
      elsif(a == 3)
        print "@"
      end
    }
    puts
  }
  puts
end

# ボード情報の初期化
# ボードは行→縦の二次元配列
def gen_board
  Array board = Array.new(8)
  for lnum in 0..7
    Array line = [0,0,0,0,0,0,0,0]
    if(lnum == 3)
      line[3] = 1
      line[4] = 2
    elsif(lnum == 4)
      line[3] = 2
      line[4] = 1
    end
    board[lnum] = line
  end
  return board
end

# 置ける箇所をマークしてくれる関数
# 引数は盤面と先手後手を表す0, 1
# 返り値はマーク済の盤面
def mark(board, locs)
  for l in locs
    board[l[0]][l[1]] = 3
  end
  return board
end

# マークを外します
def unmark board
  board.each {|line|
    for cnum in 0..7
      line[cnum] = 0 if line[cnum] == 3
    end
  }
end

# 置ける場所の配列を返す
# 配列の要素は[横,縦]
def detect(board, turn)
  # 上下左右、斜めからそれぞれ探す
  Array locs = Array.new

  board.each_with_index {|line, i|
    for cnum in 0..7
      # 基点となる石を見つけたらそこから置ける場所を探す
      if line[cnum] == turn
        locs.push detect_left(board, turn, [i, cnum])
        locs.push detect_right(board, turn, [i, cnum])
        locs.push detect_upper(board, turn, [i, cnum])
        locs.push detect_lower(board, turn, [i, cnum])
        locs.push detect_upper_left(board, turn, [i, cnum])
        locs.push detect_upper_right(board, turn, [i, cnum])
        locs.push detect_lower_left(board, turn, [i, cnum])
        locs.push detect_lower_right(board, turn, [i, cnum])
      end
    end
  }

  # nilと重複を除外して返す
  return locs.compact.uniq
end

# 指定された座標から左方向に置ける位置を探す
def detect_left(board, turn, point)
  lnum = point[0]
  cnum = point[1]

  # 指定されたポイントから左方向に検索する
  until cnum <= 0
    cnum = cnum - 1
    if board[lnum][cnum] == 0
      # 何も置いていない場合
      if board[lnum][cnum + 1] == turn
        # 右側が同じ色なら置けない
        return nil
      else
        # 右側が違う色なら置ける
        return [lnum, cnum]
      end
    elsif board[lnum][cnum] == turn
      # 同じ色が置いてある場合、置けないのですぐ返す
      return nil
    elsif board[lnum][cnum] != turn
      # 違う色が置いてある場合、さらに左を検索
      return detect_left(board, turn, [lnum, cnum])
    end

  end
  return nil
end

# 指定された座標から右方向に置ける位置を探す
def detect_right(board, turn, point)
  lnum = point[0]
  cnum = point[1]

  # 指定されたポイントから右方向に検索する
  until cnum >= 7
    cnum = cnum + 1
    if board[lnum][cnum] == 0
      # 何も置いていない場合
      if board[lnum][cnum - 1] == turn
        # 左側が同じ色なら置けない
        return nil
      else
        # 左側が違う色なら置ける
        return [lnum, cnum]
      end
    elsif board[lnum][cnum] == turn
      # 同じ色が置いてある場合、置けないのですぐ返す
      return nil
    elsif board[lnum][cnum] != turn
      # 違う色が置いてある場合、さらに右を検索
      return detect_right(board, turn, [lnum, cnum])
    end

  end
  return nil
end

# 指定された座標から上方向に置ける位置を検索する
def detect_upper(board, turn, point)
  lnum = point[0]
  cnum = point[1]

  # 指定されたポイントから上方向に検索する
  until lnum <= 0
    lnum = lnum - 1
    if board[lnum][cnum] == 0
      # 何も置いていない場合
      if board[lnum + 1][cnum] == turn
        # 下側が同じ色なら置けない
        return nil
      else
        # 下側が違う色なら置ける
        return [lnum, cnum]
      end
    elsif board[lnum][cnum] == turn
      # 同じ色が置いてある場合、置けないのですぐ返す
      return nil
    elsif board[lnum][cnum] != turn
      # 違う色が置いてある場合、さらに上を検索
      return detect_upper(board, turn, [lnum, cnum])
    end

  end
  return nil
end

# 指定された座標から下方向に置ける位置を検索する
def detect_lower(board, turn, point)
  lnum = point[0]
  cnum = point[1]

  # 指定されたポイントから下方向に検索する
  until lnum >= 7
    lnum = lnum + 1
    if board[lnum][cnum] == 0
      # 何も置いていない場合
      if board[lnum - 1][cnum] == turn
        # 上側が同じ色なら置けない
        return nil
      else
        # 上側が違う色なら置ける
        return [lnum, cnum]
      end
    elsif board[lnum][cnum] == turn
      # 同じ色が置いてある場合、置けないのですぐ返す
      return nil
    elsif board[lnum][cnum] != turn
      # 違う色が置いてある場合、さらに下を検索
      return detect_lower(board, turn, [lnum, cnum])
    end

  end
  return nil
end

# 指定された座標から左上方向に置ける位置を検索する
def detect_upper_left(board, turn, point)
  lnum = point[0]
  cnum = point[1]

  # 指定されたポイントから左上方向に検索する
  until lnum <= 0 || cnum <= 0
    lnum = lnum - 1
    cnum = cnum - 1
    if board[lnum][cnum] == 0
      # 何も置いていない場合
      if board[lnum + 1][cnum + 1] == turn
        # 右下側が同じ色なら置けない
        return nil
      else
        # 右下側が違う色なら置ける
        return [lnum, cnum]
      end
    elsif board[lnum][cnum] == turn
      # 同じ色が置いてある場合、置けないのですぐ返す
      return nil
    elsif board[lnum][cnum] != turn
      # 違う色が置いてある場合、さらに左上を検索
      return detect_upper_left(board, turn, [lnum, cnum])
    end

  end
  return nil
end

# 指定された座標から右上方向に置ける位置を検索する
def detect_upper_right(board, turn, point)
  lnum = point[0]
  cnum = point[1]

  # 指定されたポイントから右上方向に検索する
  until lnum <= 0 || cnum >= 7
    lnum = lnum - 1
    cnum = cnum + 1
    if board[lnum][cnum] == 0
      # 何も置いていない場合
      if board[lnum + 1][cnum - 1] == turn
        # 左下側が同じ色なら置けない
        return nil
      else
        # 左下側が違う色なら置ける
        return [lnum, cnum]
      end
    elsif board[lnum][cnum] == turn
      # 同じ色が置いてある場合、置けないのですぐ返す
      return nil
    elsif board[lnum][cnum] != turn
      # 違う色が置いてある場合、さらに右上を検索
      return detect_upper_right(board, turn, [lnum, cnum])
    end

  end
  return nil
end

# 指定された座標から左下方向に置ける位置を検索する
def detect_lower_left(board, turn, point)
  lnum = point[0]
  cnum = point[1]

  # 指定されたポイントから左下方向に検索する
  until lnum >= 7 || cnum <= 0
    lnum = lnum + 1
    cnum = cnum - 1
    if board[lnum][cnum] == 0
      # 何も置いていない場合
      if board[lnum - 1][cnum + 1] == turn
        # 右上側が同じ色なら置けない
        return nil
      else
        # 右上側が違う色なら置ける
        return [lnum, cnum]
      end
    elsif board[lnum][cnum] == turn
      # 同じ色が置いてある場合、置けないのですぐ返す
      return nil
    elsif board[lnum][cnum] != turn
      # 違う色が置いてある場合、さらに左下を検索
      return detect_lower_left(board, turn, [lnum, cnum])
    end

  end
  return nil
end

# 指定された座標から右下方向に置ける位置を検索する
def detect_lower_right(board, turn, point)
  lnum = point[0]
  cnum = point[1]

  # 指定されたポイントから右下方向に検索する
  until lnum >= 7 || cnum >= 7
    lnum = lnum + 1
    cnum = cnum + 1
    if board[lnum][cnum] == 0
      # 何も置いていない場合
      if board[lnum - 1][cnum - 1] == turn
        # 左上側が同じ色なら置けない
        return nil
      else
        # 左上側が違う色なら置ける
        return [lnum, cnum]
      end
    elsif board[lnum][cnum] == turn
      # 同じ色が置いてある場合、置けないのですぐ返す
      return nil
    elsif board[lnum][cnum] != turn
      # 違う色が置いてある場合、さらに右下を検索
      return detect_lower_right(board, turn, [lnum, cnum])
    end

  end
  return nil
end

# 盤面情報を更新する関数
# 引数は盤面と、置く場所（行、列）、先手後手を表す0, 1
# 返り値は更新後の盤面
def flip(board, location, turn)
  # 置ける場所のマークを消す
  unmark board

  # 置く
  board[location[0]][location[1]] = turn

  # 挟んだ石を返す（縦横斜めそれぞれ確認する）
  flip_left(board, location, turn)
  flip_right(board, location, turn)
  flip_upper(board, location, turn)
  flip_lower(board, location, turn)
  flip_upper_left(board, location, turn)
  flip_upper_right(board, location, turn)
  flip_lower_left(board, location, turn)
  flip_lower_right(board, location, turn)

  return board
end

# 置いた箇所より左方向の盤面を更新
def flip_left(board, location, turn)
  # 現在地を一つ左にずらす
  lnum = location[0]
  cnum = location[1] - 1

  if cnum < 0
    # 端を越えたらそこで終了
    return false
  end

  if board[lnum][cnum] == 0
    # 現在値に何も石がなければひっくり返せない
    return false
  elsif board[lnum][cnum] == turn
    # 現在値が同色の場合、右側を確認して、ひっくり返す必要があるか返す
    return board[lnum][cnum + 1] != turn
  elsif board[lnum][cnum] != turn
    # 現在地が異色の場合、さらに左を確認
    if flip_left(board, [lnum, cnum], turn)
      # 現在地より左側に同色が存在したならひっくり返す
      if turn == 1
        board[lnum][cnum] = 1
      elsif turn == 2
        board[lnum][cnum] = 2
      end
    else
      return
    end
  end
end

# 置いた箇所より左方向の盤面を更新
def flip_right(board, location, turn)
  # 現在地を一つ右にずらす
  lnum = location[0]
  cnum = location[1] + 1

  if cnum > 7
    # 端を越えたらそこで終了
    return false
  end

  if board[lnum][cnum] == 0
    # 現在値に何も石がなければひっくり返せない
    return false
  elsif board[lnum][cnum] == turn
    # 現在値が同色の場合、左側を確認して、ひっくり返す必要があるか返す
    return board[lnum][cnum - 1] != turn
  elsif board[lnum][cnum] != turn
    # 現在地が異色の場合、さらに右を確認
    if flip_right(board, [lnum, cnum], turn)
      # 現在地より右側に同色が存在したならひっくり返す
      if turn == 1
        board[lnum][cnum] = 1
      elsif turn == 2
        board[lnum][cnum] = 2
      end
    else
      return
    end
  end
end

# 置いた箇所より上方向の盤面を更新
def flip_upper(board, location, turn)
  # 現在地を一つ上にずらす
  lnum = location[0] - 1
  cnum = location[1]

  if lnum < 0
    # 端を越えたらそこで終了
    return false
  end

  if board[lnum][cnum] == 0
    # 現在値に何も石がなければひっくり返せない
    return false
  elsif board[lnum][cnum] == turn
    # 現在値が同色の場合、下側を確認して、ひっくり返す必要があるか返す
    return board[lnum + 1][cnum] != turn
  elsif board[lnum][cnum] != turn
    # 現在地が異色の場合、さらに上を確認
    if flip_upper(board, [lnum, cnum], turn)
      # 現在地より上側に同色が存在したならひっくり返す
      if turn == 1
        board[lnum][cnum] = 1
      elsif turn == 2
        board[lnum][cnum] = 2
      end
    else
      return
    end
  end
end

# 置いた箇所より下方向の盤面を更新
def flip_lower(board, location, turn)
  # 現在地を一つ下にずらす
  lnum = location[0] + 1
  cnum = location[1]

  if lnum > 7
    # 端を越えたらそこで終了
    return false
  end

  if board[lnum][cnum] == 0
    # 現在値に何も石がなければひっくり返せない
    return false
  elsif board[lnum][cnum] == turn
    # 現在値が同色の場合、上側を確認して、ひっくり返す必要があるか返す
    return board[lnum - 1][cnum] != turn
  elsif board[lnum][cnum] != turn
    # 現在地が異色の場合、さらに下を確認
    if flip_lower(board, [lnum, cnum], turn)
      # 現在地より下側に同色が存在したならひっくり返す
      if turn == 1
        board[lnum][cnum] = 1
      elsif turn == 2
        board[lnum][cnum] = 2
      end
    else
      return
    end
  end
end

# 置いた箇所より左上方向の盤面を更新
def flip_upper_left(board, location, turn)
  # 現在地を一つ左上にずらす
  lnum = location[0] - 1
  cnum = location[1] - 1

  if lnum < 0 || cnum < 0
    # 端を越えたらそこで終了
    return false
  end

  if board[lnum][cnum] == 0
    # 現在値に何も石がなければひっくり返せない
    return false
  elsif board[lnum][cnum] == turn
    # 現在値が同色の場合、右下側を確認して、ひっくり返す必要があるか返す
    return board[lnum + 1][cnum + 1] != turn
  elsif board[lnum][cnum] != turn
    # 現在地が異色の場合、さらに左上を確認
    if flip_upper_left(board, [lnum, cnum], turn)
      # 現在地より左上側に同色が存在したならひっくり返す
      if turn == 1
        board[lnum][cnum] = 1
      elsif turn == 2
        board[lnum][cnum] = 2
      end
    else
      return
    end
  end
end

# 置いた箇所より右上方向の盤面を更新
def flip_upper_right(board, location, turn)
  # 現在地を一つ右上にずらす
  lnum = location[0] - 1
  cnum = location[1] + 1

  if lnum < 0 || cnum > 7
    # 端を越えたらそこで終了
    return false
  end

  if board[lnum][cnum] == 0
    # 現在値に何も石がなければひっくり返せない
    return false
  elsif board[lnum][cnum] == turn
    # 現在値が同色の場合、左下側を確認して、ひっくり返す必要があるか返す
    return board[lnum + 1][cnum - 1] != turn
  elsif board[lnum][cnum] != turn
    # 現在地が異色の場合、さらに右上を確認
    if flip_upper_right(board, [lnum, cnum], turn)
      # 現在地より右上側に同色が存在したならひっくり返す
      if turn == 1
        board[lnum][cnum] = 1
      elsif turn == 2
        board[lnum][cnum] = 2
      end
    else
      return
    end
  end
end

# 置いた箇所より左下方向の盤面を更新
def flip_lower_left(board, location, turn)
  # 現在地を一つ左下にずらす
  lnum = location[0] + 1
  cnum = location[1] - 1

  if lnum > 7 || cnum < 0
    # 端を越えたらそこで終了
    return false
  end

  if board[lnum][cnum] == 0
    # 現在値に何も石がなければひっくり返せない
    return false
  elsif board[lnum][cnum] == turn
    # 現在値が同色の場合、右上側を確認して、ひっくり返す必要があるか返す
    return board[lnum - 1][cnum + 1] != turn
  elsif board[lnum][cnum] != turn
    # 現在地が異色の場合、さらに左下を確認
    if flip_lower_left(board, [lnum, cnum], turn)
      # 現在地より左下側に同色が存在したならひっくり返す
      if turn == 1
        board[lnum][cnum] = 1
      elsif turn == 2
        board[lnum][cnum] = 2
      end
    else
      return
    end
  end
end

# 置いた箇所より右下方向の盤面を更新
def flip_lower_right(board, location, turn)
  p "lower right"
  # 現在地を一つ右下にずらす
  lnum = location[0] + 1
  cnum = location[1] + 1

  if lnum > 7 || cnum > 7
    # 端を越えたらそこで終了
    return false
  end

  p board[lnum][cnum]
  if board[lnum][cnum] == 0
    # 現在値に何も石がなければひっくり返せない
    p "non"
    return false
  elsif board[lnum][cnum] == turn
    # 現在値が同色の場合、左上側を確認して、ひっくり返す必要があるか返す
    return board[lnum - 1][cnum - 1] != turn
  elsif board[lnum][cnum] != turn
    # 現在地が異色の場合、さらに右下を確認
    if flip_lower_right(board, [lnum, cnum], turn)
      # 現在地より右下側に同色が存在したならひっくり返す
      if turn == 1
        board[lnum][cnum] = 1
      elsif turn == 2
        board[lnum][cnum] = 2
      end
    else
      return
    end
  end
end

# ターン交代の処理を行う
# 返り値として次のターンの数値を返す
def turn_change(board, turn)
  # ボードをクリアして次のターンの数値を返す
  unmark board
  if turn == 1
    return 2
  elsif turn == 2
    return 1
  end
end

# 勝敗の判定を行う
# 0 = ドロー, 1 = 白の勝利, 2 = 黒の勝利
def judge(board)
  white = 0
  black = 0

  board.each {|line|
    white = white + line.count(1)
    black = black + line.count(2)
  }

  puts "*** RESULT ***"
  puts "white = " + white.to_s
  puts "black = " + black.to_s

  if white == black
    puts "[draw]"
  elsif white > black
    puts "[white won]"
  elsif white < black
    puts "[black won]"
  end
  puts
end

# 入力を求める関数
# 引数は盤面と、置ける場所
# 返り値は置く場所（行、列）
# 入力値は検証してエラーなら再入力を求める
def input(board, locs)
  while true
    puts "Please input => line,column (e.g. 1, 2): "
    input = gets
    puts

    # splitして各要素をtrim
    i_loc = input.split(",").map{|x| x.strip}

    # 検証
    begin
      validate_input(i_loc, locs)

      # 問題がなければ入力を数値の配列にして返す
      # その際、表示の数値を座標の数値に変換する（表示の都合上、1ずれているのを修正）
      # validate_input と変換処理が重複しているが、可読性のために許容している
      return i_loc.map{|x| x.to_i - 1}
    rescue StandardError => e
      puts e.message
      puts
    end
  end
end

# 入力値の検証
def validate_input(input, locs)
  # 要素数
  if input.length != 2
    raise StandardError.new("Error. Please input in valid format. => line, column")
  end

  # 数値かどうか
  begin
    i_input = input.map{|x| Integer(x) - 1}
  rescue ArgumentError
    raise StandardError.new("Error. Please input number.")
  end

  # 置けるかどうか
  if !locs.include?(i_input)
    p i_input
    p locs
    raise StandardError.new("Error. Cannot select there.")
  end
end

# ゲームのメイン処理
def game
  # ボード生成
  Array board = gen_board
  exit_flag = false

  # 先手は白
  turn = 1
  while true
    if turn == 1
      puts "*** white turn ***"
    else turn == 2
      puts "*** black turn ***"
    end

    # 置ける座標を取得
    locs = detect(board, turn)

    # 置けるところをマークして表示
    mark(board, locs)
    show board

    # 置ける場所がない場合
    if locs.length == 0
      puts "skip your turn"
      puts
      if exit_flag
        # 終了フラグが立っていたらゲーム終了
        break
      else
        # 終了フラグが立っていなければターン交代
        turn = turn_change(board, turn)
        exit_flag = true
        next
      end
    else
      exit_flag = false
    end

    # 入力
    i_loc = input(board, locs)

    # 置く（置いたらひっくり返す）
    board = flip(board, i_loc, turn)

    # 次のターンへ（ボードのマークを外して手番を交代）
    turn = turn_change(board, turn)
  end

  # 結果を表示してゲーム終了
  judge board
  return
end

puts "*** GAME START ***"
puts "● = white stone"
puts "○ = black stone"
puts "@ = selectable point"
puts

# ゲーム開始
game

puts "*** GAME OVER ***"
