package kr.bit.controller;


import kr.bit.entity.Board;
import kr.bit.mapper.BoardMapper;
import org.apache.ibatis.annotations.Update;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequestMapping("/board")
@RestController   //ajax통신 //  @ResponeBody 생략가능
public class BoardRestController {

    //rest api
    @Autowired
    BoardMapper boardMapper;

    //get post delete put
    @GetMapping("/all")
    public List<Board> boardList(){
        List<Board> list = boardMapper.getLists();
        return list;  //객체를 json데이터 형식으로 변환
    }

    @PostMapping("/new")
    public void boardInsert(Board vo){
        boardMapper.boardInsert(vo);
    }

    @DeleteMapping("/{idx}")
    public void boardDelete(@PathVariable("idx") int idx){
        boardMapper.boardDelete(idx);
    }

    @PutMapping("/update")
    public void boardUpdate(@RequestBody Board board) {

        boardMapper.boardUpdate(board);
    }

    @GetMapping("/{idx}")
    public Board boardContent(@PathVariable("idx") int idx){
        Board board=boardMapper.boardContent(idx);
        return board;
    }

    @PutMapping("/cnt/{idx}")
    public Board boardCnt(@PathVariable("idx") int idx){
        boardMapper.boardCnt(idx);
        Board board = boardMapper.boardContent(idx);
        return board;
    }




}
