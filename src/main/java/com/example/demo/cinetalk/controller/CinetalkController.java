package com.example.demo.cinetalk.controller;

import com.example.demo.cinetalk.dto.CinetalkDTO;
import com.example.demo.cinetalk.service.CinetalkService;
import com.example.demo.movie.service.MovieService;
import com.example.demo.user.dto.UserDTO;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user")
public class CinetalkController {

    private final CinetalkService cinetalkService;
    private final MovieService movieService;

    // GET /user/cinetalk 요청 시 실행
    @GetMapping("/cinetalk")
    public String cinetalkList(Model model) {
        // DB에서 씨네톡 목록 조회
        List<CinetalkDTO> talkList = cinetalkService.getAllTalks();

        // JSP 화면으로 데이터 전달
        model.addAttribute("talkList", talkList);

        return "cinetalk"; // /WEB-INF/views/user/cinetalk.jsp (본인 JSP 경로에 맞게 지정)
    }

    // 2. 🔴 [GET] 글쓰기 페이지 이동
    @GetMapping("/cinetalk/write")
    public String writeForm(HttpSession session, RedirectAttributes rttr, Model model) {
        // 비로그인 사용자 방어 (로그인 안 되어 있으면 로그인 페이지로)
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            // 2. 리다이렉트가 발생하는 conditional 안쪽으로 이동
            rttr.addFlashAttribute("alertMsg", "로그인이 필요한 서비스입니다.");
            return "redirect:/user/login";
        }

        model.addAttribute("movies", movieService.selectMovieMasterList());
        return "cinetalk_write";
    }

    // 3. 🔴 [POST] 글 작성 처리
    @PostMapping("/cinetalk/write")
    public String writeProcess(@RequestParam Long movieId,
                               @RequestParam String content,
                               HttpSession session,
                               RedirectAttributes rttr) {
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            rttr.addFlashAttribute("alertMsg", "로그인이 필요한 서비스입니다.");
            return "redirect:/user/login";
        }

        if (content == null || content.isBlank() || content.length() > 2000) {
            rttr.addFlashAttribute("alertMsg", "내용은 1자 이상 2,000자 이하로 입력해 주세요.");
            return "redirect:/user/cinetalk/write";
        }

        var movie = movieService.selectMovieMasterListById(movieId);
        CinetalkDTO cinetalkDTO = new CinetalkDTO();
        cinetalkDTO.setTitle(String.valueOf(movie.get("title")));
        cinetalkDTO.setContent(content.trim());
        cinetalkDTO.setUserId(loginUser.getUserId());
        cinetalkService.writeTalk(cinetalkDTO);

        // 작성 완료 후 씨네톡 메인 피드로 이동
        return "redirect:/user/cinetalk";
    }

    // 글 삭제 처리
    @PostMapping("/cinetalk/delete")
    public String deleteProcess(Long talkId, HttpSession session) {
        System.out.println("======> 넘겨받은 삭제 글 번호(talkId): " + talkId); // 👈 콘솔 확인용 Log

        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser != null && talkId != null) {
            cinetalkService.deleteTalk(talkId);
            System.out.println("======> 삭제 서비스 실행 완료!");
        } else {
            System.out.println("======> 삭제 실패: 로그인 상태가 아니거나 talkId가 null입니다.");
        }

        return "redirect:/user/cinetalk";
    }
}
