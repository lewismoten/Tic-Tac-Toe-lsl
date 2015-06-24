string map = "xxxo ooox xoo   o xx  x oxoxx";
string mapTexture = "f399855a-4cbe-f1fe-038d-d42da9be9893";
string blankMark = " ";
string aiMark = "o";
string playerMark = "x";

string oldBoard;
string board;
list rowFace = [7,4,6];

integer playerXTurn = FALSE;
key playerId = NULL_KEY;
integer gameEnded = 0;
integer gameStarted = 0;
key gameOverId = "00000000-DEAD-0000-0000-000000000000";

integer difficulty = 0;
integer difficulty_easy = 0;
integer difficulty_normal = 1;
integer difficulty_hard = 2;
integer difficulty_impossible = 3;

integer chance(integer percent)
{
    if(llRound(llFrand(100)) <= percent)
        return TRUE;
    return FALSE;
}
showGameOn()
{
    llSetPrimitiveParams([PRIM_TEXTURE, 1, mapTexture, <0.25, 0.5, 0>, <0.125, -.7, 0>, PI_BY_TWO]);
}
showTouchToPlay()
{
    llSetPrimitiveParams([PRIM_TEXTURE, 1, mapTexture, <0.25, 0.5, 0>, <0.125, -.45, 0>, PI_BY_TWO]);
}
showTieGame()
{
    llSetPrimitiveParams([PRIM_TEXTURE, 1, mapTexture, <0.25, 0.5, 0>, <0.375, -.45, 0>, PI_BY_TWO]);
}
showPlayerXWins()
{
    llSetPrimitiveParams([PRIM_TEXTURE, 1, mapTexture, <0.25, 0.5, 0>, <0.375, -.7, 0>, PI_BY_TWO]);
}
showPlayerOWins()
{
    llSetPrimitiveParams([PRIM_TEXTURE, 1, mapTexture, <0.25, 0.5, 0>, <0.375, -.95, 0>, PI_BY_TWO]);
}
computerMark()
{
    ai(aiMark, playerMark);
    nextPlayer();
}
ai(string mark, string oponentMark)
{
    
    // this is the strategy in order of preference.
    // it guarantees wins and tie games
    // to give player the chance to win:
        // add random choice to implement each movement choice

    if(difficulty != difficulty_easy)
    {
        
        // go for win if two in a row
        if(aiCompleteTwo(mark, mark)) 
        {
           // llWhisper(PUBLIC_CHANNEL, "Ah hah!");
            return;
        }
        
        // block player if they have 2 in a row
        if(aiCompleteTwo(oponentMark, mark)) 
        {
            //llWhisper(PUBLIC_CHANNEL, "I'm not going to make it that easy for you!");
            return;
        }
    }
    
    if(difficulty == difficulty_impossible || (difficulty == difficulty_hard && chance(50)))
    {
    
        // Now that we have blocking and winning, let's get advanced
        // and setup wins
        
        
        
        // fork to win in two ways
        if(aiFork(mark, mark)) 
        {
           // llWhisper(PUBLIC_CHANNEL, "Oh, what a delema you have now!");
            return;
        }
    }
    if(difficulty == difficulty_impossible || (difficulty == difficulty_hard && chance(50)))
    {
    
        // block opponents fork
        if(aiFork(oponentMark, mark)) 
        {
           // llWhisper(PUBLIC_CHANNEL, "You are sneaky, but I am two steps ahead of you!");
            return;
        }
    }
    
    if(difficulty != difficulty_easy)
    {
        // play center
        if(aiCenter(mark)) 
        {
       //     llWhisper(PUBLIC_CHANNEL, "I like the middle");
            return;
        }
        
        // play opposite corner if openent is in corner
        if(aiOppositeCorner(mark, oponentMark)) 
        {
         //   llWhisper(PUBLIC_CHANNEL, "I'll take the other corner.");
            return;
        }
        
        // play a corner
        if(aiPlayCorner(mark)) 
        {
        //    llWhisper(PUBLIC_CHANNEL, "I like this corner");
            return;
        }
    
        // ok, let's just pick what is left now
        
        // play empty side
        if(aiPlayEmptySide(mark)) 
        {
          //  llWhisper(PUBLIC_CHANNEL, "Not much left. I'll go with this side.");
            return;
        }
    }
    
    // we should never get this far if all strategy is implemented
    // however, if a strategy rule is bypassed, let's choose a random location
    aiPlayRandom(mark);
  //  llWhisper(PUBLIC_CHANNEL, "Hmm... not sure what I should choose.");
    
}

aiPlayRandom(string mark)
{
    integer row = llRound(llFrand(300)) % 3;
    integer col = llRound(llFrand(300)) % 3;

    while(getMarkAt(col, row) != blankMark)
    {
        row = llRound(llFrand(300)) % 3;
        col = llRound(llFrand(300)) % 3;
    }
        
    setMarkAt(col, row, mark);
}
integer aiCompleteTwo(string mark, string placementMark)
{
    integer row;
    integer col;
    
    string mark0x0 = getMarkAt(0, 0);
    string mark0x1 = getMarkAt(0, 1);
    string mark0x2 = getMarkAt(0, 2);

    string mark1x0 = getMarkAt(1, 0);
    string mark1x1 = getMarkAt(1, 1);
    string mark1x2 = getMarkAt(1, 2);
        
    string mark2x0 = getMarkAt(2, 0);
    string mark2x1 = getMarkAt(2, 1);
    string mark2x2 = getMarkAt(2, 2);
    
    // row check
    for(row = 0; row < 3; row++)
    {
        if(canWin(mark,
            getMarkAt(0, row),
            getMarkAt(1, row),
            getMarkAt(2, row)) == TRUE)
        {
            if(getMarkAt(0, row) == blankMark) setMarkAt(0, row, placementMark);
            else if(getMarkAt(1, row) == blankMark) setMarkAt(1, row, placementMark);
            else if(getMarkAt(2, row) == blankMark) setMarkAt(2, row, placementMark);
            return TRUE;
        }
    }
    
    // col check
    for(col = 0; col < 3; col++)
    {
        if(canWin(mark,
            getMarkAt(col, 0),
            getMarkAt(col, 1),
            getMarkAt(col, 2)))
        {
            if(getMarkAt(col, 0) == blankMark) setMarkAt(col, 0, placementMark);
            else if(getMarkAt(col, 1) == blankMark) setMarkAt(col, 1, placementMark);
            else if(getMarkAt(col, 2) == blankMark) setMarkAt(col, 2, placementMark);
            return TRUE;
        }
    }

    // diagonal check
    
    if(canWin(mark, mark0x0, mark1x1, mark2x2))
    {
        if(mark0x0 == blankMark) setMarkAt(0, 0, placementMark);
        else if(mark1x1 == blankMark) setMarkAt(1, 1, placementMark);
        else if(mark2x2 == blankMark) setMarkAt(2, 2, placementMark);
        return TRUE;
    }
    
    if(canWin(mark, mark2x0, mark1x1, mark0x2))
    {
        if(mark2x0 == blankMark) setMarkAt(2, 0, placementMark);
        else if(mark1x1 == blankMark) setMarkAt(1, 1, placementMark);
        else if(mark0x2 == blankMark) setMarkAt(0, 2, placementMark);
        return TRUE;
    }
        
    return FALSE;
}
vector emptyCell(string mark, integer col, integer row)
{
    string mark0x0 = getMarkAt(0, 0);
    string mark0x1 = getMarkAt(0, 1);
    string mark0x2 = getMarkAt(0, 2);

    string mark1x0 = getMarkAt(1, 0);
    string mark1x1 = getMarkAt(1, 1);
    string mark1x2 = getMarkAt(1, 2);
        
    string mark2x0 = getMarkAt(2, 0);
    string mark2x1 = getMarkAt(2, 1);
    string mark2x2 = getMarkAt(2, 2);

    if(col == 0 && row == 0)
    {
        if(mark1x0 == mark && mark2x0 == blankMark) return <2, 0, 0>;
        if(mark2x0 == mark && mark1x0 == blankMark) return <1, 0, 0>;
        if(mark1x1 == mark && mark2x2 == blankMark) return <2, 2, 0>;
        if(mark2x2 == mark && mark1x1 == blankMark) return <1, 1, 0>;
        if(mark0x1 == mark && mark0x2 == blankMark) return <0, 2, 0>;
        if(mark0x2 == mark && mark0x1 == blankMark) return <0, 1, 0>;
    }
    if(col == 1 && row == 0)
    {
        if(mark0x0 == mark && mark2x0 == blankMark) return <2, 0, 0>;
        if(mark2x0 == mark && mark0x0 == blankMark) return <0, 0, 0>;
        if(mark1x1 == mark && mark1x2 == blankMark) return <1, 2, 0>;
        if(mark1x2 == mark && mark1x1 == blankMark) return <1, 1, 0>;
    }
    if(col == 2 && row == 0)
    {
        if(mark0x0 == mark && mark1x0 == blankMark) return <1, 0, 0>;
        if(mark1x0 == mark && mark0x0 == blankMark) return <0, 0, 0>;
        if(mark1x1 == mark && mark0x2 == blankMark) return <0, 2, 0>;
        if(mark0x2 == mark && mark1x1 == blankMark) return <1, 1, 0>;
        if(mark2x1 == mark && mark2x2 == blankMark) return <2, 2, 0>;
        if(mark2x2 == mark && mark2x1 == blankMark) return <2, 1, 0>;
    }
    if(col == 0 && row == 1)
    {
        if(mark1x1 == mark && mark2x1 == blankMark) return <2, 1, 0>;
        if(mark2x1 == mark && mark1x1 == blankMark) return <1, 1, 0>;
        if(mark0x0 == mark && mark0x2 == blankMark) return <0, 2, 0>;
        if(mark0x2 == mark && mark0x0 == blankMark) return <0, 0, 0>;
    }
    if(col == 1 && row == 1)
    {
        if(mark0x0 == mark && mark2x2 == blankMark) return <2, 2, 0>;
        if(mark2x2 == mark && mark0x0 == blankMark) return <0, 0, 0>;
        if(mark0x2 == mark && mark2x0 == blankMark) return <2, 0, 0>;
        if(mark2x0 == mark && mark0x2 == blankMark) return <0, 2, 0>;
        if(mark0x1 == mark && mark2x1 == blankMark) return <2, 1, 0>;
        if(mark2x1 == mark && mark0x1 == blankMark) return <0, 1, 0>;
        if(mark1x0 == mark && mark1x2 == blankMark) return <1, 2, 0>;
        if(mark1x2 == mark && mark1x0 == blankMark) return <1, 0, 0>;
    }
    if(col == 2 && row == 1)
    {
        if(mark2x0 == mark && mark2x2 == blankMark) return <2, 2, 0>;
        if(mark2x2 == mark && mark2x0 == blankMark) return <2, 0, 0>;
        if(mark0x1 == mark && mark1x1 == blankMark) return <1, 1, 0>;
        if(mark1x1 == mark && mark0x1 == blankMark) return <0, 1, 0>;
    }
    if(col == 0 && row == 2)
    {
        if(mark1x2 == mark && mark2x2 == blankMark) return <2, 2, 0>;
        if(mark2x2 == mark && mark1x2 == blankMark) return <1, 2, 0>;
        if(mark1x1 == mark && mark2x0 == blankMark) return <2, 0, 0>;
        if(mark2x0 == mark && mark1x1 == blankMark) return <1, 1, 0>;
        if(mark2x1 == mark && mark2x2 == blankMark) return <2, 2, 0>;
        if(mark2x2 == mark && mark2x1 == blankMark) return <2, 1, 0>;
    }
    if(col == 1 && row == 2)
    {
        if(mark0x2 == mark && mark2x2 == blankMark) return <2, 2, 0>;
        if(mark2x2 == mark && mark0x2 == blankMark) return <0, 2, 0>;
        if(mark1x1 == mark && mark1x0 == blankMark) return <1, 0, 0>;
        if(mark1x0 == mark && mark1x1 == blankMark) return <1, 1, 0>;
    }
    if(col == 2 && row == 2)
    {
        if(mark0x2 == mark && mark1x2 == blankMark) return <1, 2, 0>;
        if(mark1x2 == mark && mark0x2 == blankMark) return <0, 2, 0>;
        if(mark1x1 == mark && mark0x0 == blankMark) return <0, 0, 0>;
        if(mark0x0 == mark && mark1x1 == blankMark) return <1, 1, 0>;
        if(mark2x1 == mark && mark2x0 == blankMark) return <2, 0, 0>;
        if(mark2x0 == mark && mark2x1 == blankMark) return <2, 1, 0>;
    }
    
    return <-1, -1, -1>;
}
integer canWin(string mark, string mark1, string mark2, string mark3)
{
    if(mark == mark1 && mark1 == mark2 && mark3 == blankMark) return TRUE;
    if(mark == mark2 && mark2 == mark3 && mark1 == blankMark) return TRUE;
    if(mark == mark3 && mark3 == mark1 && mark2 == blankMark) return TRUE;
    return FALSE;
}
integer canWin2(string mark, string mark1, string mark2, string mark3)
{
    if(mark == mark1 && mark2 == mark3 && mark3 == blankMark) return TRUE;
    if(mark == mark2 && mark3 == mark1 && mark1 == blankMark) return TRUE;
    if(mark == mark3 && mark1 == mark2 && mark2 == blankMark) return TRUE;
    return FALSE;
}
integer canWin3(string mark, integer col, integer row)
{
    string mark0x0 = getMarkAt(0, 0);
    string mark0x1 = getMarkAt(0, 1);
    string mark0x2 = getMarkAt(0, 2);

    string mark1x0 = getMarkAt(1, 0);
    string mark1x1 = getMarkAt(1, 1);
    string mark1x2 = getMarkAt(1, 2);
        
    string mark2x0 = getMarkAt(2, 0);
    string mark2x1 = getMarkAt(2, 1);
    string mark2x2 = getMarkAt(2, 2);
    
    if(col == 0 && row == 0)
    {
        if(canWin(mark, mark, mark1x0, mark2x0)) return TRUE;
        if(canWin(mark, mark, mark1x1, mark2x2)) return TRUE;
        if(canWin(mark, mark, mark0x1, mark0x2)) return TRUE;
    }
    
    if(col == 1 && row == 0)
    {
        if(canWin(mark, mark, mark0x0, mark2x0)) return TRUE;
        if(canWin(mark, mark, mark1x1, mark1x2)) return TRUE;
    }
    
    if(col == 2 && row == 0)
    {
        if(canWin(mark, mark, mark1x0, mark0x0)) return TRUE;
        if(canWin(mark, mark, mark2x1, mark2x2)) return TRUE;
        if(canWin(mark, mark, mark1x1, mark0x2)) return TRUE;
    }
    
    if(col == 0 && row == 1)
    {
        if(canWin(mark, mark, mark0x0, mark0x2)) return TRUE;
        if(canWin(mark, mark, mark1x1, mark2x1)) return TRUE;
    }
    
    if(col == 1 && row == 1)
    {
        if(canWin(mark, mark, mark0x1, mark2x1)) return TRUE;
        if(canWin(mark, mark, mark1x0, mark1x2)) return TRUE;
        if(canWin(mark, mark, mark0x0, mark2x2)) return TRUE;
        if(canWin(mark, mark, mark2x0, mark0x2)) return TRUE;
    }
    
    if(col == 2 && row == 1)
    {
        if(canWin(mark, mark, mark0x1, mark1x1)) return TRUE;
        if(canWin(mark, mark, mark2x0, mark2x2)) return TRUE;
    }
    
    if(col == 0 && row == 2)
    {
        if(canWin(mark, mark, mark1x1, mark2x0)) return TRUE;
        if(canWin(mark, mark, mark0x0, mark0x1)) return TRUE;
        if(canWin(mark, mark, mark1x2, mark2x2)) return TRUE;
    }
    
    if(col == 1 && row == 2)
    {
        if(canWin(mark, mark, mark0x2, mark2x2)) return TRUE;
        if(canWin(mark, mark, mark1x0, mark1x1)) return TRUE;
    }
    
    if(col == 2 && row == 2)
    {
        if(canWin(mark, mark, mark0x2, mark1x2)) return TRUE;
        if(canWin(mark, mark, mark2x0, mark2x1)) return TRUE;
        if(canWin(mark, mark, mark1x1, mark0x0)) return TRUE;
    }
    
    return FALSE;
}
integer aiFork(string mark, string placementMark)
{
    string mark0x0 = getMarkAt(0, 0);
    string mark0x1 = getMarkAt(0, 1);
    string mark0x2 = getMarkAt(0, 2);

    string mark1x0 = getMarkAt(1, 0);
    string mark1x1 = getMarkAt(1, 1);
    string mark1x2 = getMarkAt(1, 2);
        
    string mark2x0 = getMarkAt(2, 0);
    string mark2x1 = getMarkAt(2, 1);
    string mark2x2 = getMarkAt(2, 2);
    
    integer row0 = canWin2(mark, mark0x0, mark1x0, mark2x0);
    integer row1 = canWin2(mark, mark0x1, mark1x1, mark2x1);
    integer row2 = canWin2(mark, mark0x2, mark1x2, mark2x2);
    integer col0 = canWin2(mark, mark0x0, mark0x1, mark0x2);
    integer col1 = canWin2(mark, mark1x0, mark1x1, mark1x2);
    integer col2 = canWin2(mark, mark2x0, mark2x1, mark2x2);
    integer dia0 = canWin2(mark, mark0x0, mark1x1, mark2x2); // \
    integer dia1 = canWin2(mark, mark2x0, mark1x1, mark0x2); // /

    list forks = [];
        
    // find all possible forks
    
    if(mark0x0 == blankMark && ((row0 && (dia0 || col0)) || (dia0 && col0)))
        forks += [<0,0,0>];
    if(mark1x0 == blankMark && row0 && col1) 
        forks += [<1,0,0>];
    if(mark2x0 == blankMark && ((row0 && (dia1 || col2)) || (dia1 && col2)))
        forks += [<2, 0, 0>];
    if(mark0x1 == blankMark && col0 && row1) 
        forks += [<0, 1, 0>];
    if(mark1x1 == blankMark && ((col1 && (row1 || dia0 || dia1)) || (row1 && (dia0 || dia1)) || (dia0 && dia1)))
        forks += [<1, 1, 0>];
    if(mark2x1 == blankMark && col2 && row1) 
        forks += [<2, 1, 0>];
    if(mark0x2 == blankMark && ((row2 && (dia1 || col0)) || (dia1 && col0)))
        forks += [<0, 2, 0>];
    if(mark1x2 == blankMark && row2 && col1)
        forks += [<1, 2, 0>];
    if(mark2x2 == blankMark && ((row2 && (dia0 || col2)) || (dia0 && col2)))
        forks += [<2, 2, 0>];

    integer n = llGetListLength(forks);
    integer i;
    vector v;
    integer col;
    integer row;
    list offense = [];
    
        
    // go on offensive if this is an opponents potential fork
    if(mark != placementMark)
    {
        // find location to put 2 in a row, but does not lead to fork in opponents next move
       
        // if one of the forks is in a corner, go for side
        for(i = 0; i < n; i++)
        {
            vector v = llList2Vector(forks, i);
            col = llRound(v.x);
            row = llRound(v.y);
            
            // if is corner
            if((col == 0 && row == 0) || (col == 0 && row == 2) || (col == 2 && row == 0) || (col == 2 && row == 2))
            {
                
                // go for side
                if(llListFindList(offense, [<0, 1, 0>]) == -1 && canWin3(placementMark, 0, 1)) offense += <0, 1, 0>;
                if(llListFindList(offense, [<1, 0, 0>]) == -1 && canWin3(placementMark, 1, 0)) offense += <1, 0, 0>;
                if(llListFindList(offense, [<1, 2, 0>]) == -1 && canWin3(placementMark, 1, 2)) offense += <1, 2, 0>;
                if(llListFindList(offense, [<2, 1, 0>]) == -1 && canWin3(placementMark, 2, 1)) offense += <2, 1, 0>;
            }
            // if is side
            else if((col == 0 && row == 1) || (col == 1 && row == 0) || (col == 1 && row == 2) || (col == 2 && row == 1))
            {
                // go for corner
                if(llListFindList(offense, [<0, 0, 0>]) == -1 && canWin3(placementMark, 0, 0)) offense += <0, 0, 0>;
                if(llListFindList(offense, [<2, 0, 0>]) == -1 && canWin3(placementMark, 2, 0)) offense += <2, 0, 0>;
                if(llListFindList(offense, [<0, 2, 0>]) == -1 && canWin3(placementMark, 0, 2)) offense += <0, 2, 0>;
                if(llListFindList(offense, [<2, 2, 0>]) == -1 && canWin3(placementMark, 2, 2)) offense += <2, 2, 0>;
            }
            // if is center
            else if(col == 1 && row == 1)
            {
                // go for center
                if(canWin3(placementMark, 1, 1)) offense += <1, 1, 0>;
            }
            
        }
        // now we have all offensive positions, we need to find one that doesn't force opponent to make a fork
        n = llGetListLength(offense);
        for(i = 0; i < n; i++)
        {
            vector v = llList2Vector(offense, i);
            col = llRound(v.x);
            row = llRound(v.y);
            
            // find empty cell to complete row
            vector block = emptyCell(placementMark, col, row);
            
            // if empty cell does not lead to opponent forking
            if(block.z != -1 && llListFindList(forks, [block]) == -1)
            {
                // place the mark
                setMarkAt(col, row, placementMark);
                return TRUE;
            }
        }
        
        
    }

    // if possible forks not found, do nothing
    if(llGetListLength(forks) == 0)
        return FALSE;
        
    v = llList2Vector(forks, 0);
    
    col = llRound(v.x);
    row = llRound(v.y);
    
    setMarkAt(col, row, placementMark);
    
    return TRUE;
}
integer aiCenter(string mark)
{
    if(getMarkAt(1, 1) == blankMark)
    {
        setMarkAt(1, 1, mark);
        return TRUE;
    }
    return FALSE;
}
integer aiOppositeCorner(string mark, string oponentMark)
{
    list cells = [];
    
    if(getMarkAt(0, 0) == blankMark && getMarkAt(2, 2) == oponentMark)
        cells += <0, 0, 0>;
    if(getMarkAt(2, 0) == blankMark && getMarkAt(0, 2) == oponentMark)
        cells += <2, 0, 0>;
    if(getMarkAt(0, 2) == blankMark && getMarkAt(2, 0) == oponentMark)
        cells += <0, 2, 0>;
    if(getMarkAt(2, 2) == blankMark && getMarkAt(0, 0) == oponentMark)
        cells += <2, 2, 0>;
    
    integer n = llGetListLength(cells);
    if(n == 0) return FALSE;
    integer i = llRound(llFrand(n * 100)) % n;
    vector cell = llList2Vector(cells, i);
    setMarkAt(llRound(cell.x), llRound(cell.y), mark);
    return TRUE;
}
integer aiPlayCorner(string mark)
{
    list cells = [];
    
    if(getMarkAt(0, 0) == blankMark) cells += <0, 0, 0>;
    if(getMarkAt(2, 0) == blankMark) cells += <2, 0, 0>;
    if(getMarkAt(0, 2) == blankMark) cells += <0, 2, 0>;
    if(getMarkAt(2, 2) == blankMark) cells += <2, 2, 0>;

    integer n = llGetListLength(cells);
    if(n == 0) return FALSE;
    integer i = llRound(llFrand(n * 100)) % n;
    vector cell = llList2Vector(cells, i);
    setMarkAt(llRound(cell.x), llRound(cell.y), mark);
    return TRUE;
}
integer aiPlayEmptySide(string mark)
{
    list cells = [];
    
    if(getMarkAt(1, 0) == blankMark) cells += <1, 0, 0>;
    if(getMarkAt(0, 1) == blankMark) cells += <0, 1, 0>;
    if(getMarkAt(2, 1) == blankMark) cells += <2, 1, 0>;
    if(getMarkAt(1, 2) == blankMark) cells += <1, 2, 0>;
    
    integer n = llGetListLength(cells);
    if(n == 0) return FALSE;
    integer i = llRound(llFrand(n * 100)) % n;
    vector cell = llList2Vector(cells, i);
    setMarkAt(llRound(cell.x), llRound(cell.y), mark);
    return TRUE;
}
nextPlayer()
{
    playerXTurn = !playerXTurn;
    
    string mark = winner();
    
    if(mark != " ")
    {
        if(mark == "x")
            showPlayerXWins();
        else if(mark == "o")
            showPlayerOWins();
        else if(mark == "xo")
            showTieGame();
        
        playerId = gameOverId;
        llSetTimerEvent(5.0);
        return;
    }
    if(!playerXTurn)
        computerMark();
}
string winner()
{
    integer row;
    integer col;
    string mark;
    
    // row check
    for(row = 0; row < 3; row++)
    {
        integer rowStart = row * 3;
        string rowText = llGetSubString(board, rowStart, rowStart + 2);
        if(rowText == "xxx") return "x";
        if(rowText == "ooo") return "o";
    }
    
    // col check
    for(col = 0; col < 3; col++)
    {
        mark = getMarkAt(col, 0);
        if(mark != " "
        && mark == getMarkAt(col, 1)
        && mark == getMarkAt(col, 2))
            return mark;
    }

    // diagonal check
    mark = getMarkAt(1,1);
    if(mark != " ")
    {
        if(mark == getMarkAt(0,0)
        && mark == getMarkAt(2,2))
            return mark;
            
        if(mark == getMarkAt(0,2)
        && mark == getMarkAt(2,0))
            return mark;
    }
    
    // tie
    if(llSubStringIndex(board, " ") == -1)
        return "xo";
    
    // no winners
    return " ";
}
newGame()
{
    board = "         ";
    playerXTurn = TRUE;
    updateDisplay();
    showTouchToPlay();
    playerId = NULL_KEY;
    gameStarted = 0;
    gameEnded = 0;
    llSetTimerEvent(0);
}
string getMarkAt(integer col, integer row)
{
    return llGetSubString(board, row * 3 + col, row * 3 + col);
    
}
setMarkAt(integer col, integer row, string mark)
{
    integer index = row * 3 + col;
    board = llDeleteSubString(board, index, index);
    board = llInsertString(board, index, mark);
    updateDisplay();
    
}
list mapRow(integer row)
{
    integer rowStart = row * 3;

    string rowText = llGetSubString(board, rowStart, rowStart + 2);
    string oldRowText = llGetSubString(oldBoard, rowStart, rowStart + 2);
    
    if(rowText == oldRowText)
        return [];
    
    integer index = llSubStringIndex(map, rowText);
    
    integer face = llList2Integer(rowFace, row);
    
    float singleWidth = 1.0 / 27.0;
    float tripletWidth = 1.0 / 9.0;
    
    vector repeats = <tripletWidth, .25, 0>;
    vector offsets = <(index / 27.0) - (.5) + (singleWidth * 1.5), -0.375, 0>;
    float rotation_in_radians = PI_BY_TWO;
    
    if(row == 1)
    {
        repeats.x *= -1;
        repeats.y = 4;
        offsets.y = -0.675;
        rotation_in_radians = -PI_BY_TWO;
    }
    
    return 
    [
        PRIM_TEXTURE, 
        face, 
        mapTexture, 
        repeats, 
        offsets, 
        rotation_in_radians 
    ];
}
updateDisplay()
{
    integer row;
    list rules = [];
    for(row = 0; row < 3; row++)
        rules += mapRow(row);
    if(llGetListLength(rules) != 0)
        llSetPrimitiveParams(rules);
    oldBoard = board;
}
translateTouch(key id, integer face, vector pos)
{
    
    integer row = llListFindList(rowFace, [face]);
    if(row == -1) return;
    
    integer col = 0;
    vector pos = pos;
//    if(row != 2) pos.y = 1 - pos.x;
    if(pos.y > .3333)
    {
        if(pos.y > .6666) 
            col = 2;
        else
            col = 1;
    }
    string mark = getMarkAt(col, row);
    
    if(mark != " ")
    {
        llInstantMessage(id, "That area is already marked.");
        return;
    }
    if(playerXTurn)
        setMarkAt(col, row, "x");
    else
        setMarkAt(col, row, "o");
        
    nextPlayer();
 }
default
{
    state_entry()
    {
        newGame();
    }

    touch_start(integer total_number)
    {
        integer i;
        for(i = 0; i < total_number; i++)
        {
            integer face = llDetectedTouchFace(i);
            
            if(face == 0xFFFFFFFF)// TOUCH_INVALID_FACE
            {
                llInstantMessage(llDetectedKey(i), "Your viewier does not appear to support touch detection.");
            }
            else if(face == 0 || face == 2 || face == 5)
            {
                // 2 - back
                // 0 - right
                // 5 - left
                llInstantMessage(llDetectedKey(i), "Try touching a different part.");
            }
            else if(face == 3) // top panel
            {
                if(playerId == NULL_KEY)
                {
                    difficulty ++;
                    difficulty %= 4;
                    if(difficulty == difficulty_easy)
                        llInstantMessage(llDetectedKey(i), "Difficulty: Easy");
                    else if(difficulty == difficulty_normal)
                        llInstantMessage(llDetectedKey(i), "Difficulty: Normal");
                    else if(difficulty == difficulty_hard)
                        llInstantMessage(llDetectedKey(i), "Difficulty: Hard");
                    else if(difficulty == difficulty_impossible)
                        llInstantMessage(llDetectedKey(i), "Difficulty: Impossible");
                }
            }
            else if(playerId == NULL_KEY || playerId == llDetectedKey(i))
            {
                if(playerId == NULL_KEY)
                {
                    llSetTimerEvent(305.0);
                    gameStarted == llGetUnixTime();
                    playerId = llDetectedKey(i);
                    showGameOn();
                }
                if(face != 1) // bottom panel
                {
                    vector pos = llDetectedTouchST(i);
                    translateTouch(llDetectedKey(i), face, pos);
                }
            }
            
        }
    }
    timer()
    {
        // new game timed out
        if(playerId == gameOverId)
        {
            newGame();
            return;
        }
        // game timed out
        if(playerId != NULL_KEY && llGetUnixTime() - gameStarted > 300)
        {
            newGame();
        }
    }
}