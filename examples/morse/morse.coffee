root = exports ? this

unit = 75
duration =
    short_mark: unit * 1
    long_mark: unit * 3
    element_gap: unit * 1
    short_gap: unit * 3
    long_gap: unit * 7

signal_chain = (head, tail...) ->
    [time, f] = head
    f time
    if tail.length > 0
        setTimeout ( -> signal_chain tail...),  (time + duration['element_gap'])

root.encode = (text, sample_rate=2000, frequency=800) ->
    text = text.toLowerCase().trim()
    text.replace /\s+/g, " "
    b = new Beep sample_rate
    signal = (duration) -> b.play frequency, duration/1000.0, [Beep.utils.amplify(10000)]
    dit = [duration['short_mark'], signal]
    dah = [duration['long_mark'], signal]
    space = [duration['long_gap'], (x) -> x]
    letter_end = [duration['short_gap'], (x) -> x]

    ###
    board = document.getElementById "code"
    dit = [duration['short_mark'], -> board.innerHTML += '.']
    dah = [duration['long_mark'], -> board.innerHTML += '-']
    space = [duration['long_gap'], -> board.innerHTML += '/']
    letter_end = [duration['short_gap'], -> board.innerHTML += ',']
    ###

    lookup = make_table dit, dah, space, letter_end
    # lookup all the letters
    characters = (lookup[ch] for ch in text when lookup[ch]?)
    # add a pause between letters
    #characters.map (a) -> a.push(letter_end)
    # flatten the list of [duration, callable]s
    sounds = [].concat(characters...)
    # play them sequentially
    signal_chain(sounds...)

make_table = (dit, dah, space, letter_end) ->
    # dit and dah could anything, depending on
    # what you want your table for
    morse =
        a: [dit, dah, letter_end] 
        b: [dah, dit, dit, dit, letter_end]
        c: [dah, dit, dah, dit, letter_end]
        d: [dah, dit, dit, letter_end]
        e: [dit, letter_end]
        f: [dit, dit, dah, dit, letter_end]
        g: [dah, dah, dit, letter_end]
        h: [dit, dit, dit, dit, letter_end]
        i: [dit, dit, letter_end]
        j: [dit, dah, dah, dah, letter_end]
        k: [dah, dit, dah, letter_end]
        l: [dit, dah, dit, dit, letter_end]
        m: [dah, dah, letter_end]
        n: [dah, dit, letter_end]
        o: [dah, dah, dah, letter_end]
        p: [dit, dah, dah, dit, letter_end]
        q: [dah, dah, dit, dah, letter_end]
        r: [dit, dah, dit, letter_end]
        s: [dit, dit, dit, letter_end]
        t: [dah, letter_end]
        u: [dit, dit, dah, letter_end]
        v: [dit, dit, dit, dah, letter_end]
        w: [dit, dah, dah, letter_end]
        x: [dah, dit, dit, dah, letter_end]
        y: [dah, dit, dah, dah, letter_end]
        z: [dah, dah, dit, dit, letter_end]
        1: [dit, dah, dah, dah, dah]
        2: [dit, dit, dah, dah, dah]
        3: [dit, dit, dit, dah, dah]
        4: [dit, dit, dit, dit, dah]
        5: [dit, dit, dit, dit, dit]
        6: [dah, dit, dit, dit, dit]
        7: [dah, dah, dit, dit, dit]
        8: [dah, dah, dah, dit, dit]
        9: [dah, dah, dah, dah, dit]
        0: [dah, dah, dah, dah, dah]
        ".": [dit, dah, dit, dah, dit, dit, dah]
        ",": [dah, dah, dit, dit, dah, dah]
        "?": [dit, dit, dah, dah, dit, dit]
        "'": [dit, dah, dah, dah, dah, dit]
        "!": [dah, dit, dah, dit, dah, dah]
        "/": [dah, dit, dit, dah, dit]
        "(": [dah, dit, dah, dah, dit]
        ")": [dah, dit, dah, dah, dit, dah]
        "&": [dit, dah, dit, dit, dit]
        ":": [dah, dah, dah, dit, dit, dit]
        ";": [dah, dit, dah, dit, dah, dit]
        "=": [dah, dit, dit, dit, dah]
        "+": [dit, dah, dit, dah, dit]
        "-": [dah, dit, dit, dit, dah]
        "_": [dit, dit, dah, dah, dit, dah]
        "\"": [dit, dah, dit dit, dah, dit]
        "$": [dit, dit, dit, dah, dit dit, dah]
        "@": [dit, dah, dah, dit, dah, dit]
        " ": [space]
