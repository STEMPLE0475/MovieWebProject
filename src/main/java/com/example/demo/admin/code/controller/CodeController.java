package com.example.demo.admin.code.controller;

import com.example.demo.admin.code.service.CodeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/code")
@RequiredArgsConstructor
public class CodeController {

    private final CodeService codeService;

    @GetMapping("/list")
    public String codeListPage(Model model) {
        Map<String, Object> param = new HashMap<>();
        param.put("group_code", "LOCATION");
        param.put("use_yn", "Y");
        model.addAttribute("parentCodeList", codeService.searchCode(param));
        return "admin/code";
    }

    @ResponseBody
    @GetMapping
    public List<Map<String, Object>> searchCode(@RequestParam Map<String, Object> param) {
        return codeService.searchCode(param);
    }

    @ResponseBody
    @PostMapping
    public Map<String, Object> insertCode(@RequestParam Map<String, Object> param) {
        codeService.insertCode(param);
        return param; // selectKey로 채워진 code_id 포함해서 그대로 반환
    }

    @ResponseBody
    @PutMapping("/{codeId}")
    public void updateCode(@PathVariable String codeId, @RequestParam Map<String, Object> param) {
        param.put("code_id", codeId);
        codeService.updateCode(param);
    }

    @ResponseBody
    @DeleteMapping("/{codeId}")
    public void nonUseCode(@PathVariable String codeId) {
        Map<String, Object> param = new HashMap<>();
        param.put("code_id", codeId);
        codeService.nonUseCode(param);
    }
}