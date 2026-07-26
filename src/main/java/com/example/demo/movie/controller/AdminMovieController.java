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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

    @PostMapping("/admin/movies")
    public String insertMovieMaster(@RequestParam Map<String, Object> param, RedirectAttributes redirectAttributes) {
        movieService.insertMovieMaster(param);
        redirectAttributes.addFlashAttribute("message", "Movie registered successfully.");
        return "redirect:/admin/movies";
    }

    @GetMapping("/admin/movies/{movieId}/edit")
    public String editMovieForm(@PathVariable Long movieId, Model model) {
        model.addAttribute("movie", movieService.selectMovieMasterListById(movieId));
        model.addAttribute("formMode", "edit");
        return "admin/movie-form";
    }

    @PostMapping("/admin/movies/{movieId}")
    public String updateMovieMaster(@PathVariable Long movieId, @RequestParam Map<String, Object> param, RedirectAttributes redirectAttributes) {
        param.put("movieId", movieId);
        movieService.updateMovieMaster(param);
        redirectAttributes.addFlashAttribute("message", "Movie updated successfully.");
        return "redirect:/admin/movies";
    }

    @PostMapping("/admin/movies/{movieId}/delete")
    public String deleteMovieMasterById(@PathVariable Long movieId, RedirectAttributes redirectAttributes) {
        movieService.deleteMovieMasterById(movieId);
        redirectAttributes.addFlashAttribute("message", "Movie deleted successfully.");
        return "redirect:/admin/movies";
    }
}