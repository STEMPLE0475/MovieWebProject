package com.example.demo.movie.controller;

import com.example.demo.movie.service.MovieService;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequiredArgsConstructor
public class AdminMovieController {
    private final MovieService movieService;

    @GetMapping("/admin/movies")
    public String movies(Model model) {
        model.addAttribute("movies", movieService.selectMovieMasterList());
        return "admin/movie-list";
    }

    @GetMapping("/admin/movies/new")
    public String newMovieForm(Model model) {
        model.addAttribute("formMode", "create");
        return "admin/movie-form";
    }

    @ResponseBody
    @PostMapping("/admin/movies")
    public Map<String, String> insertMovieMaster(@RequestParam Map<String, Object> param) {
        movieService.insertMovieMaster(param);
        return Map.of("message", "영화를 등록했습니다.");
    }

    @GetMapping("/admin/movies/{movieId}/edit")
    public String editMovieForm(@PathVariable Long movieId, Model model) {
        model.addAttribute("movie", movieService.selectMovieMasterListById(movieId));
        model.addAttribute("formMode", "edit");
        return "admin/movie-form";
    }

    @ResponseBody
    @PostMapping("/admin/movies/{movieId}")
    public Map<String, String> updateMovieMaster(@PathVariable Long movieId, @RequestParam Map<String, Object> param) {
        param.put("movieId", movieId);
        movieService.updateMovieMaster(param);
        return Map.of("message", "영화 정보를 수정했습니다.");
    }

    @ResponseBody
    @PostMapping("/admin/movies/{movieId}/delete")
    public Map<String, String> deleteMovieMasterById(@PathVariable Long movieId) {
        movieService.deleteMovieMasterById(movieId);
        return Map.of("message", "영화를 삭제했습니다.");
    }
}
