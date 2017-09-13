function ICDdiagnoisisFields() {
    var b;
    var c;
    var e;
    var d = $("[id$=searchDiagnosisId]");
    var a = $("[id$=diagnosisTextId]");
    a.autocomplete({
        minLength: 2,
        source: function(g, f) {
            e = g.term;
            WishReferralForm_AC.searchDiagnosis(g.term, function(h, i) {
                if (i.type == "exception") {
                    alert(i.message)
                } else {
                    c = h;
                    f(c)
                }
            })
        },
        focus: function(f, g) {
            a.val(g.item.Name);
            return false
        },
        select: function(g, h) {
            var f = h.item.Condition_Description__c;
            d.val("");
            d.prop("disabled", true);
            $("[id$=shortTextId]").text("Description: " + h.item.Short_Description__c);
            d.rules("remove");
            d.css("border", "").removeAttr("aria-required aria-describedby");
            d.parents().removeClass("has-error");
            d.parents().parents().children(".col-md-3").children("label").css("color", "");
            d.next(".error").remove();
            if (typeof f != "undefined") {
                d.val(h.item.Condition_Description__r.Name);
                $(".searchDiagnosisId").val(h.item.Condition_Description__r.Name)
            }
            return false
        },
    }).data("ui-autocomplete")._renderItem = function(f, h) {
        var g = "<a>" + h.Name;
        g = g + "</a>";
        g = g.replace(e, "<b>" + e + "</b>");
        return $("<li></li>").data("ui-autocomplete-item", h).append(g).appendTo(f)
    };
    a.keyup(function() {
        if ($(this).val() == "") {
            d.val("");
            d.prop("disabled", false);
            d.text("")
        }
    });
    d.keyup(function() {
        if ($(this).val() == "") {
            d.val("");
            d.prop("disabled", false)
        }
    });
    d.val(b);
    d.on("focus", function(f) {
        $tgt = $(f.target);
        if ($tgt.val() === b) {
            $tgt.val("");
            $tgt.removeClass("placeHolder")
        }
    });
    d.on("blur", function(f) {
        $tgt = $(f.target);
        if ($tgt.val() === "") {
            $tgt.val(b);
            $tgt.addClass("placeHolder")
        }
    });
    d.autocomplete({
        minLength: 2,
        source: function(g, f) {
            e = g.term;
            WishReferralForm_AC.searchCondition(g.term, function(h, i) {
                if (i.type == "exception") {
                    alert(i.message)
                } else {
                    c = h;
                    f(c)
                }
            })
        },
        focus: function(f, g) {
            d.val(g.item.Name);
            return false
        },
        select: function(g, h) {
            a.val("");
            a.prop("disabled", false);
            d.val(h.item.Name);
            var f = h.item.Code_To_Use__c;
            if (typeof f != "undefined") {
                a.val(h.item.Code_To_Use__c);
                a.prop("disabled", true)
            }
            return false
        },
    }).data("ui-autocomplete")._renderItem = function(f, h) {
        var g = "<a>" + h.Name;
        g = g + "</a>";
        g = g.replace(e, "<b>" + e + "</b>");
        return $("<li></li>").data("ui-autocomplete-item", h).append(g).appendTo(f)
    };
    d.val(b);
    d.on("focus", function(f) {
        $tgt = $(f.target);
        if ($tgt.val() === b) {
            $tgt.val("");
            $tgt.removeClass("placeHolder")
        }
    });
    d.on("blur", function(f) {
        $tgt = $(f.target);
        if ($tgt.val() === "") {
            $tgt.val(b);
            $tgt.addClass("placeHolder")
        }
    })
}
ICDdiagnoisisFields();
if (window.matchMedia("(min-width: 47.5rem)").matches) {
    $(".phonemask").mask("(999) 999-9999").attr("maxlength", "15")
}
$(".phonemask").attr("type", "tel");
$("[id$=wcdob]").removeAttr("onfocus").mask("99/99/9999", {
    placeholder: "mm/dd/yyyy"
});
$("[id$=email],[id$=pemailaddress],[id$=mpemail]").attr("type", "email");
$(".r2c fieldset table tr td").children().unwrap().unwrap().unwrap().unwrap().unwrap();
$(".r2c input:first").clone().prependTo(".r2c label:first");
$(".r2c input:nth-child(3)").clone().prependTo(".r2c label:nth-child(4)");
$(".r2c input:nth-child(5)").clone().prependTo(".r2c label:nth-child(6)");
$(".r2c input:nth-child(7)").clone().prependTo(".r2c label:nth-child(8)");
$(".r2c input:nth-child(9)").clone().prependTo(".r2c label:nth-child(10)");
$(".r2c > input").remove();
$(".r2c label").addClass("col-xs-12 col-md-6");
$(".r2c label input").attr("name", "r2c-radio");
$(".r2c-radio").click(function() {
    $(".familyAware").parent().parent().show()
});

function showHideAgeCheckCloneFields() {
    var k = "You cannot proceed further unless the family is aware of this referral.";
    var h = [" Self", " Medical Professional", " Parent/Guardian", " Family Member/Relative", " Other"];
    var e = [" Self", " Parent/Guardian", " Family Member/Relative"];
    var c = ["Nurse Practitioner", "Physician Assistant", "Physician"];
    var a = ["2.5", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13"];
    var m = ["firstname", "lastname", "phonechk", "email", "city", "state-chk", "address", "postalcode", "family-aware-chk", "medprovider", "r2c-manual-input", "wcgender", "wcage", "wcdob", "wcreceivedwish", "language", "siblings-chk", "icd", "pdiagnosis", "facility", "urgency", "sibage"];
    $(".familyAware").on("change", function() {
        if ($(this).val() == "No") {
            var n = $(".radioSection input:checked").parent().text();
            var o = $.inArray(n, h);
            $(".familyAwareError").css("display", "block");
            if (o > -1) {
                $(this).next(".familyAwareError").text(k);
                $(".shownOnYes").addClass("fam-aware-overlay");
                if (n == " Medical Professional") {
                    $(".medicalProvider").css("display", "none")
                }
                if (n == " Other") {
                    $(".r2c-manual-input").parent().parent().css("display", "none");
                    $(this).next(".familyAwareError").text(k)
                }
            } else {
                $(".familyAwareError").css("display", "none")
            }
        } else {
            if ($(this).val() == "Yes") {
                var n = $(".radioSection input:checked").parent().text();
                $(this).next("span").text("");
                $(".shownOnYes").removeClass("fam-aware-overlay");
                if (n == " Medical Professional") {
                    $(".medicalProvider").css("display", "block")
                }
                if (n == " Other") {
                    $(".r2c-manual-input").parent().parent().removeClass("displayNone").css("display", "block")
                }
            } else {
                $(".shownOnYes").addClass("fam-aware-overlay");
                $(".familyAwareError").css("display", "none")
            }
        }
    });
    $(".medProvCat").on("change", function() {
        var o = $(".medProvCat").val();
        var n = $.inArray(o, c);
        if (n > -1) {
            $(".repeatMedProf").css("display", "block")
        } else {
            $(".repeatMedProf").css("display", "none")
        }
    });
    $(".repeatMedProf").on("change", function() {
        checkVisible = $(".repeatMedProf input").is(":checked");
        if (checkVisible == true) {
            $(".mfirstname").val($(".rfirstname").val());
            $(".mlastname").val($(".rlastname").val());
            $(".mphone").val($(".rphone").val());
            $(".memail").val($(".remail").val())
        } else {
            if (checkVisible == false) {
                $(".medToRepeat :input").each(function() {
                    $(this).val("")
                })
            }
        }
    });

    function g() {
        var n = $(".radioSection input:checked").parent().text();
        if ((n == " Self")) {
            $(".wcfirstname").val($(".rfirstname").val());
            $(".wclastname").val($(".rlastname").val())
        }
    }
    $(".refToRepeat :input").on("keyup", g);

    function l() {
        var n = $(".radioSection input:checked").parent().text();
        if ((n == " Parent/Guardian")) {
            $(".pfirstname").val($(".rfirstname").val());
            $(".plastname").val($(".rlastname").val());
            $(".pphone").val($(".rphone").val());
            $(".pemailaddress").val($(".remail").val());
            $(".pcity").val($(".rcity").val());
            $(".ppostalcode").val($(".rpostalcode").val())
        }
    }
    $(".refToParent :input").on("keyup", l);
    $("[id$=nSib]").on("change", function() {
        function n(s, p, r) {
            var o = 0;
            var q = window.setInterval(function() {
                s();
                if (++o === r) {
                    window.clearInterval(q)
                }
            }, p)
        }
        if ($(this).val() != "" || $(this).val() != "0" || $(this).val() != "Unknown") {
            $(".sibInfo").css("display", "block");
            if ($("input.r2c-radio[name=r2c-radio]:checked", "#j_id0\\:frm").parent().text() == " Self" || $("input.r2c-radio[name=r2c-radio]:checked", "#j_id0\\:frm").parent().text() == " Parent/Guardian") {
                n(function() {
                    $("[id$=psibfirstname]").addClass("firstname");
                    $("[id$=psiblastname]").addClass("lastname");
                    $("[id$=psibage]").addClass("sibage");
                    formValidationRules()
                }, 50, 4)
            }
        } else {
            $(".sibInfo").css("display", "none");
            n(function() {
                $("[id$=psibfirstname]").removeClass("firstname");
                $("[id$=psiblastname]").removeClass("lastname");
                $("[id$=psibage]").removeClass("sibage");
                $("input[id$=psibfirstname],input[id$=psiblastname],input[id$=psibage]").each(function() {
                    $(this).rules("remove")
                })
            }, 50, 4)
        }
    });

    function i() {
        $(".wcfirstname").val($(".rfirstname").val());
        $(".wclastname").val($(".rlastname").val());
        if ($(".wcfirstname").val() == $(".rfirstname").val()) {
            $(".wcfirstname").val("")
        }
        if ($(".wclastname").val() == $(".rlastname").val()) {
            $(".wclastname").val("")
        }
    }

    function d() {
        $(".pfirstname").val($(".rfirstname").val());
        $(".plastname").val($(".rlastname").val());
        $(".pphone").val($(".rphone").val());
        $(".pemailaddress").val($(".remail").val());
        $(".pcity").val($(".rcity").val());
        $(".ppostalcode").val($(".rpostalcode").val());
        if ($(".pfirstname").val() == $(".rfirstname").val()) {
            $(".pfirstname").val("")
        }
        if ($(".plastname").val() == $(".rlastname").val()) {
            $(".plastname").val("")
        }
        if ($(".pphone").val() == $(".rphone").val()) {
            $(".pphone").val("")
        }
        if ($(".pemailaddress").val() == $(".remail").val()) {
            $(".pemailaddress").val("")
        }
        if ($(".pcity").val() == $(".rcity").val()) {
            $(".pcity").val("")
        }
        if ($(".ppostalcode").val() == $(".rpostalcode").val()) {
            $(".ppostalcode").val("")
        }
    }

    function f() {
        var p = ["[id$=aware-of-referral],[id$=wcage],[id$=wcreceivedwish],[id$=plang],[id$=nSib],[id$=urgency]"];
        $("form[id$=frm]").validate().resetForm();

        function o() {
            $("input,select").removeClass("firstname lastname phonechk email city state-chk address postalcode family-aware-chk medprovider r2c-manual-input wcgender wcage wcdob wcreceivedwish language siblings-chk icd pdiagnosis facility urgency sibage").removeAttr("aria-required aria-describedby");
            $("select[id$=aware-of-referral],select[id$=medprov],input[id$=rfirstname],input[id$=frm\\:pfirstname],input[id$=wcfirstname]input,[id$=mpfirstname],input[id$=rlastname],input[id$=frm\\:plastname],input[id$=wclastname],input[id$=mplastname],input[id$=rphone],input[id$=pphonenumber],input[id$=mpphone],input[id$=remail],input[id$=pemailaddress],input[id$=pcity],input[id$=ppostalcode],select[id$=p-state],input[id$=wcdob],select[id$=wcgender],input[id$=paddress],select[id$=plang],input[id$=searchDiagnosisId],input[id$=mphospitalname],input[id$=psibfirstname],input[id$=psiblastname],input[id$=psibage]").each(function() {
                $(this).rules("remove")
            })
        }
        o();

        function n() {
            var s = document.querySelectorAll("select option");
            for (var t = 0, r = s.length; t < r; t++) {
                s[t].selected = s[t].defaultSelected
            }
        }
        n(p);
        $(".sibInfo").css("display", "none");
        $("[id$=aware-of-referral]").parent().parent().css("display", "block");
        $("[id$=aware-of-referral]").prop("selectedIndex", 0);
        var q = $("[id$=p-state]").parents().parents();
        $(q).removeClass("has-error").children(".col-md-3").children("label").css("color", "");
        $(q).children(".col-md-6").children(".chosen-container-single").children(".chosen-single").css("border", "");
        $(q).children(".col-md-6").children(".help-block").remove()
    }
    $(".radioClickable input").click(function() {
        var o = $(".radioSection input:checked").parent().text();
        var n = $.inArray(o, e);
        f();
        $("[id$=wcage]").parents(".form-group").addClass("sr-only");
        $(".shownOnYes").addClass("fam-aware-overlay");
        j();
        if (o != "") {
            $(".Relchild").val(o)
        }
        if (n > -1) {
            $(".referrerInfo").css("display", "block");
            $(".medicalProvider,.other").css("display", "none");
            if (n == -1 || n == 2) {
                i();
                d()
            }
        }
        if (o == " Medical Professional") {
            $(".medProvCat").val("");
            $(".referrerInfo,.medicalProvider").css("display", "block");
            $(".other").css("display", "none");
            $("[id$=aware-of-referral]").addClass("family-aware-chk");
            $("[id$=medprov]").addClass("medprovider");
            $("[id$=rfirstname],[id$=frm\\:pfirstname],[id$=wcfirstname],[id$=mplastname]").addClass("firstname");
            $("[id$=rlastname],[id$=frm\\:plastname],[id$=wclastname],[id$=mplastname]").addClass("lastname");
            $("[id$=rphone],[id$=pphonenumber],[id$=mpphone]").addClass("phonechk");
            $("[id$=remail]").addClass("email");
            $("[id$=pcity]").addClass("city");
            $("[id$=ppostalcode]").addClass("postalcode");
            $("[id$=p-state]").addClass("state-chk");
            $("[id$=wcdob]").addClass("wcdob");
            $("[id$=wcgender]").addClass("wcgender");
            $("[id$=paddress]").addClass("address");
            $("[id$=plang]").addClass("language");
            $("[id$=searchDiagnosisId]").addClass("pdiagnosis");
            $("[id$=mphospitalname]").addClass("facility");
            formValidationRules();
            i();
            d()
        } else {
            if (o == " Other") {
                $(".other input").val("");
                $(".referrerInfo,.other").css("display", "block");
                $(".medicalProvider").css("display", "none");
                $("[id$=aware-of-referral]").addClass("family-aware-chk");
                $("[id$=r2cManualInput]").addClass("r2c-manual-input");
                $("[id$=rfirstname],[id$=wcfirstname],[id$=frm\\:pfirstname]").addClass("firstname");
                $("[id$=rlastname],[id$=frm\\:plastname],[id$=wclastname]").addClass("lastname");
                $("[id$=rphone]").addClass("phonechk");
                $("[id$=remail]").addClass("email");
                $("[id$=rcity]").addClass("city");
                $("[id$=rpostalcode]").addClass("postalcode");
                formValidationRules();
                $("[id$=searchDiagnosisId]").addClass("pdiagnosis");

                $("[id$=wcage]").parents(".form-group").removeClass("sr-only");
                $(".repeatMedProf").css("display", "none");
                i();
                d()
            } else {
                if (o == " Self" || o == " Parent/Guardian" || o == " Family Member/Relative") {
                    $("[id$=rfirstname],[id$=frm\\:pfirstname],[id$=wcfirstname]").addClass("firstname");
                    $("[id$=rlastname],[id$=frm\\:plastname],[id$=wclastname],[id$=mplastname]").addClass("lastname");
                    $("[id$=rphone],[id$=pphonenumber]").addClass("phonechk");
                    $("[id$=remail]").addClass("email");
                    $("[id$=pcity]").addClass("city");
                    $("[id$=ppostalcode]").addClass("postalcode");
                    $("[id$=p-state]").addClass("state-chk");
                    $("[id$=nSib],[id$=psibfirstname],[id$=psiblastname],[id$=psibage]").addClass("sibling-chk");
                    $("[id$=wcdob]").addClass("wcdob");
                    $("[id$=wcgender]").addClass("wcgender");
                    $("[id$=paddress]").addClass("address");
                    $("[id$=plang]").addClass("language");
                    $("[id$=searchDiagnosisId]").addClass("pdiagnosis");
                    $("[id$=mphospitalname]").addClass("facility");
                    $(".repeatMedProf").css("display", "none");
                    if (o == " Self" || o == " Family Member/Relative") {
                        $("[id$=aware-of-referral]").addClass("family-aware-chk")
                    }
                    if (o == " Self") {
                        g();
                        b();
                        d()
                    } else {
                        if (o == " Parent/Guardian") {
                            $(".shownOnYes").removeClass("fam-aware-overlay");
                            $("[id$=aware-of-referral]").parent().parent().css("display", "none");
                            $('[id$=aware-of-referral] option[value="Yes"]').prop("selected", true)
                        }
                    }
                    formValidationRules();
                    l();
                    i()
                }
            }
        }
    });

    function b() {
        var n = $(".childAge").val();
        var o = $(".radioSection input:checked").parent().text();
        var p = $.inArray(n, a);
        if (p > "-1" && o == " Self") {
            $(".alertMsg").text("Please confirm that you have received your parent or guardian’s permission to complete this form.");
            $("#age13under-modal").modal("show")
        }
    }
    $(".childAge").on("change", function() {
        var n = $("age-text").text();
        if ($(this).val() == "Under 2.5" || $(this).val() == "18 & Above") {
            $(".alertMsg").text("To be eligible, children must be older than 2 ½ years old and younger than 18 years old.");
            $("#warningModal").modal("show")
        }
        if ($("select.childAge option:nth-child(20)").length > 0) {
            $("select.childAge option:last-child").remove()
        }
        if ($("select.childAge").val() != n) {
            $("[id$=wcdob]").val("");
            $(".age-text").fadeOut(300, function() {
                $(this).remove()
            });
            $("[id$=wcdob]").unmask();
            $("[id$=wcdob]").mask("99/99/9999", {
                placeholder: "mm/dd/yyyy",
            })
        }
        b()
    });

    function j() {
        $("[id$=wcdob]").on("keyup", function() {
            var x = $("[id$=wcage]");
            var y = $("[id$=wcdob]");
            var p = $("[id$=wcdob]").val();
            var w = new Date();
            var t = new Date(p);
            var z = 24 * 60 * 60 * 1000;
            var s = Math.round(Math.abs((w.getTime() - t.getTime()) / (z)));
            var n = $(this).val();
            var r = 0;
            var v = ["m", "d", "y"];
            var u = n.indexOf("m") && n.indexOf("d") && n.indexOf("y");
            var o = (function() {
                var B = 0;
                return function(D, C) {
                    clearTimeout(B);
                    B = setTimeout(D, C)
                }
            })();

            function q(F) {
                var E = new Date();
                var C = new Date(F);
                var D = E.getFullYear() - C.getFullYear();
                var B = E.getMonth() - C.getMonth();
                if (B < 0 || (B === 0 && E.getDate() < C.getDate())) {
                    D--
                }
                return D
            }

            function A() {
                if ($("select.childAge option:nth-child(20)").length > 0) {
                    $("select.childAge option:last-child").remove()
                }

                function B() {
                    $(".alertMsg").text("To be eligible, children must be older than 2 ½ years old and younger than 18 years old.");
                    $("#warningModal").modal("show")
                }
                $(".age-text").remove();
                if (s < 912.5) {
                    $(x).prop("selectedIndex", 1);
                    $('<span class="text-muted age-text">Under 2 1/2 years old</span>').insertAfter(y);
                    B()
                } else {
                    if (s >= 6570) {
                        $(x).prop("selectedIndex", 18);
                        $('<span class="text-muted age-text">Over 18 years old</span>').insertAfter(y);
                        B()
                    } else {
                        if (s > 912.5 || s < 6570) {
                            $(x).prop("selectedIndex", 0);
                            $(x).append('<option value="' + q(p) + '" selected="selected">' + q(p) + "</option>");
                            $('<span class="text-muted age-text">' + q(p) + " years old</span>").insertAfter(y)
                        }
                    }
                }
                if (s >= 4745) {
                    b()
                }
                if (q(p) < 0 || !q(p)) {
                    $(".age-text").remove();
                    $('<span class="text-muted age-text" style="color:red">Oops! Invalid Birthdate</span>').insertAfter(y);
                    o(function() {
                        $("[id$=wcdob]").val("");
                        $(".age-text").fadeOut(300, function() {
                            $(this).remove()
                        });
                        $("[id$=wcdob]").unmask();
                        $("[id$=wcdob]").mask("99/99/9999", {
                            placeholder: "mm/dd/yyyy",
                        });
                        $(x).prop("selectedIndex", 0)
                    }, 1000)
                }
            }
            while (u !== -1) {
                r++;
                u = n.indexOf(v, u + 1)
            }
            if (r === 0) {
                A()
            }
        })
    }
}
showHideAgeCheckCloneFields();
$(".submitBtn").click(function() {
    $(".searchDiagnosisId").val($(".pdiagnosis").val());
    $(".diagnosisFilter").val($(".diagnosisText").val())
});
$(".fs").hide();
$.validator.setDefaults({
    submitHandler: function() {
        if ($("#b98084695645e0e89ec5a2f3c41f0a2d").is(":checked") == true || $("#2-b98084695645e0e89ec5a2f3c41f0a2d").val() !== "udh&6**33#") {
            onsubmit: false
        } else {
            if ($(form).valid()) {
                form.submit();
                return false
            }
        }
    },
    ignore: ":hidden:not(.c-select)"
});
$("form[id$=frm]").validate({
    errorElement: "em",
    errorPlacement: function(a, b) {
        a.addClass("help-block");
        b.parents(".col-sm-6").addClass("has-feedback");
        if (b.prop("type") === "radio") {
            a.insertBefore(b.parents(".r2c"))
        } else {
            a.insertAfter(b)
        }
    },
    highlight: function(d, a, b) {
        var c = $(d).parents(".col-md-6, .col-xs-8.col-md-4, .r2c, td");
        $(c).removeClass("has-success").addClass("has-error").prev("label").css("color", "red");
        $(c).removeClass("has-success").addClass("has-error").parents(".sibInfo").children("span").children("span").children("label").css("color", "red");
        $(c).removeClass("has-success").addClass("has-error").prev("div").children("label").css("color", "red");
        $(c).children(".chosen-container-single").children(".chosen-single").css("border", "1px solid red");
        $(c).children("input, select").css("border", "1px solid red");
        $(c).children("label").css("border", "1px solid red")
    },
    unhighlight: function(d, a, b) {
        var c = $(d).parents(".col-md-6, .col-xs-8.col-md-4, .col-md-1, .r2c, td");
        $(c).removeClass("has-error").prev("label").css("color", "");
        $(c).removeClass("has-error").parents(".sibInfo").children("span").children("span").children("label").css("color", "");
        $(c).removeClass("has-error").prev("div").children("label").css("color", "");
        $(c).children(".chosen-container-single").children(".chosen-single").css("border", "");
        $(c).children("input, select").css("border", "");
        $(c).children(".help-block").remove()
    }
});

function formValidationRules() {
    $("input.firstname").each(function() {
        $(this).rules("add", {
            required: true,
            minlength: 2,
            maxlength: 40,
            messages: {
                required: "Oops! Please enter a first name",
                minlength: "Oops! Your first name must have more than 2 letters",
                maxlength: "We're sorry, you've reached the maximum allowed characters"
            }
        })
    });
    $("input.lastname").each(function() {
        $(this).rules("add", {
            required: true,
            minlength: 2,
            maxlength: 40,
            messages: {
                required: "Oops! Please enter a last name",
                minlength: "Oops! Your first name must have more than 2 letters",
                maxlength: "We're sorry, you've reached the maximum allowed characters"
            }
        })
    });
    $("input.phonechk").each(function() {
        $(this).rules("add", {
            required: true,
            phoneUS: true,
            minlength: 10,
            maxlength: 15,
            messages: {
                required: "Oops! Please enter a phone number",
                number: "Only numbers are accepted",
                minlength: "Opps! Please enter at least 10 digits",
                maxlength: "We're sorry, you've reached the maximum allowed characters"
            }
        })
    });
    $("input.email").each(function() {
        $(this).rules("add", {
            required: true,
            email: true,
            messages: {
                required: "Oops! Please enter a valid email address",
                email: "Oops! You've entered an invalid email address"
            }
        })
    });
    $("input.city").each(function() {
        $(this).rules("add", {
            required: true,
            minlength: 3,
            maxlength: 22,
            messages: {
                required: "Oops! Please enter a US city",
                minlength: "Oops! Please enter at least 3 characters",
                maxlength: "We're sorry, you've reached the maximum allowed characters"
            }
        })
    });
    $("input.postalcode").each(function() {
        $(this).rules("add", {
            required: true,
            digits: true,
            minlength: 5,
            maxlength: 9,
            messages: {
                required: "Oops! Please enter a valid US postal code",
                digits: "Oops! Please only enter digits",
                minlength: "Oops! Please enter a minimum of 5 digits",
                maxlength: "We're sorry, you've reached the maximum allowed characters"
            }
        })
    });
    $("input.sibage").each(function() {
        $(this).rules("add", {
            required: true,
            digits: true,
            minlength: 1,
            maxlength: 2,
            messages: {
                required: "Oops! Please enter this sibling's age",
                digits: "Oops! Please only enter digits",
                minlength: "Oops! Please enter a minimum of 2 digits",
                maxlength: "We're sorry, you've reached the maximum allowed characters"
            }
        })
    });
    $("input.r2c-radio").rules("add", {
        required: true,
        messages: {
            required: "Oops! Please select an option"
        }
    });
    $("select.family-aware-chk").rules("add", {
        required: true,
        messages: {
            required: "Oops! Please select an option"
        }
    });
    $("select.medprovider").rules("add", {
        required: true,
        messages: {
            required: "Oops! Please select an option"
        }
    });
    $("input.r2c-manual-input").rules("add", {
        required: true,
        minlength: 5,
        maxlength: 20,
        messages: {
            required: "Oops! Please enter your relationship to the Wish Child",
            minlength: "Oops! Please enter a minimum of 3 characters",
            maxlength: "We're sorry, you've reached the maximum allowed characters"
        }
    });
    $("select.wcage").rules("add", {
        required: true,
        messages: {
            required: "Oops! Please select the wish child's age"
        }
    });
    $("select.wcgender").rules("add", {
        required: true,
        messages: {
            required: "Oops! The child's gender is required"
        }
    });
    $("input.wcdob").rules("add", {
        required: true,
        messages: {
            required: "Oops! The child's date of birth is required"
        }
    });
    $("input.wcreceivedwish").rules("add", {
        required: true,
        messages: {
            required: "Oops! This question is required"
        }
    });
    $("input.address").rules("add", {
        required: true,
        minlength: 5,
        maxlength: 40,
        messages: {
            required: "Oops! Please enter an address",
            minlength: "Oops! Please enter a minimum of 5 characters",
            maxlength: "We're sorry, you've reached the maximum allowed characters"
        }
    });
    $("select.state-chk").rules("add", {
        required: true,
        messages: {
            required: "Oops! Please select a state"
        }
    });
    $("select.language").rules("add", {
        required: true,
        messages: {
            required: "Oops! Please select a language"
        }
    });
    $("select.siblings-chk").rules("add", {
        required: true,
        messages: {
            required: "Oops! Please select the number of siblings"
        }
    });
    $("input.icd").rules("add", {
        required: true,
        minlength: 3,
        messages: {
            required: "Oops! Please enter an ICD code",
            minlength: "Oops! Please enter a minimum of 3 characters"
        }
    });
    $("input.pdiagnosis").rules("add", {
        required: true,
        minlength: 3,
        messages: {
            required: "Oops! Please enter a primary diagnosis",
            minlength: "Oops! Please enter a minimum of 3 characters",
        }
    });
    $("input.facility").rules("add", {
        required: true,
        minlength: 3,
        messages: {
            required: "Oops! Please enter the name of the hospital or treatment facility",
            minlength: "Oops! Please enter a minimum of 3 characters",
        }
    });
    $("select.urgency").rules("add", {
        required: true,
        messages: {
            required: "Oops! Please select an option",
        }
    })
}
$(".r2c").children("label").children("input").addClass("r2c-radio");
formValidationRules();
$("select.state option:first").remove();
$(".state").prepend('<option disabled="disabled" selected="selected">Please select a State</option>');
$(".chosen").on("change", function() {
    var a = $(this).parents().parents();
    $(a).removeClass("has-error").children(".col-md-3").children("label").css("color", "");
    $(a).children(".col-md-6").children(".chosen-container-single").children(".chosen-single").css("border", "");
    $(a).children(".col-md-6").children(".help-block").remove()
});
$(".numbers-only").keydown(function(a) {
    if ($.inArray(a.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 || (a.keyCode == 65 && a.ctrlKey === true) || (a.keyCode == 67 && a.ctrlKey === true) || (a.keyCode == 88 && a.ctrlKey === true) || (a.keyCode >= 35 && a.keyCode <= 39)) {
        return
    }
    if ((a.shiftKey || (a.keyCode < 48 || a.keyCode > 57)) && (a.keyCode < 96 || a.keyCode > 105)) {
        a.preventDefault()
    }
});