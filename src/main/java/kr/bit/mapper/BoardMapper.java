package kr.bit.mapper;


import kr.bit.entity.Board;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper //mybatis api
public interface BoardMapper {

    public List<Board> getLists();
    public void boardInsert(Board vo);
    public void boardDelete(int idx);
    public void boardUpdate(Board vo);

    @Update("update bitboard set count=count+1 where idx=#{idx}")
    public void boardCnt(int idx);

    public Board boardContent(int idx);

}
