package com.msorquestrador.generic.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthCheckController {

    @GetMapping("/check")
    public String helthCheck (){
        return "Health Check!";
    }
}
