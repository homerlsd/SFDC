public class SUTCEmailMessageTemplates {

    public static String htmlScreeningBreastCancer () {
        String html = '<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"padding-bottom:10px\"><tbody>';
            html += '<tr><td style=\"width:70px\" valign=\"top\"><img src=\"' + SUTC.ASSETS_URL + 'sutc/icon-breast-cancer.png\"></td>';
            html += '<td><h3 style=\"padding-bottom:0;padding-top:0;margin-bottom:0;margin-top:0;font:200 20px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#df5546\">';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#breast-cancer\" style=\"text-decoration:none;color:#df5546;\">';
            html += 'Breast Cancer Screening (Mammogram)';
            html += '</a>';
            html += '</h3><p style=\"padding-top:0;margin-top:6px;font:normal 15px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#4d4d4d\">';
            html += 'Ladies, have your girls checked regularly! It might not be pleasant, but you want to catch any problems as early as possible. ';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#breast-cancer\" style=\"text-decoration:none;color:#df5546;white-space:nowrap;\">Get the details.</a></p>';
            html += '</td></tr>';
            html += '</tbody></table>';
        return html;
    }

    public static String htmlScreeningCervicalCancer () {
        String html = '<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"padding-bottom:10px\"><tbody>';
            html += '<tr><td style=\"width:70px\" valign=\"top\"><img src=\"' + SUTC.ASSETS_URL + 'sutc/icon-cervical-cancer.png\"></td>';
            html += '<td><h3 style=\"padding-bottom:0;padding-top:0;margin-bottom:0;margin-top:0;font:200 20px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#df5546\">';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#cervical-cancer\" style=\"text-decoration:none;color:#df5546;\">';
            html += 'Cervical Cancer Screening (Pap Test)';
            html += '</a>';
            html += '</h3><p style=\"padding-top:0;margin-top:6px;font:normal 15px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#4d4d4d\">';
            html += 'You only need testing every 3 years now, so don’t put it off! Cervical cancer is one of the easiest to catch and treat early. ';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#cervical-cancer\" style=\"text-decoration:none;color:#df5546;white-space:nowrap;\">Learn More.</a></p>';
            html += '</td></tr>';
            html += '</tbody></table>';
        return html;
    }

    public static String htmlScreeningColorectalCancer () {
        String html = '<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"padding-bottom:10px\"><tbody>';
            html += '<tr><td style=\"width:70px\" valign=\"top\"><img src=\"' + SUTC.ASSETS_URL + 'sutc/icon-colorectal-cancer.png\"></td>';
            html += '<td><h3 style=\"padding-bottom:0;padding-top:0;margin-bottom:0;margin-top:0;font:200 20px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#df5546\">';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#colorectal-cancer\" style=\"text-decoration:none;color:#df5546;\">';
            html += 'Colorectal Cancer Screening ';
            html += '</a>';
            html += '</h3><p style=\"padding-top:0;margin-top:6px;font:normal 15px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#4d4d4d\">';
            html += 'If you’re 50 to 75, you should be getting screened to catch colon polyps and cancers as early as possible. The good news is you have options. ';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#colorectal-cancer\" style=\"text-decoration:none;color:#df5546;white-space:nowrap;\">Learn More.</a></p>';
            html += '</td></tr>';
            html += '</tbody></table>';
        return html;
    }

    public static String htmlScreeningHepatitis () {
        String html = '<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"padding-bottom:10px\"><tbody>';
            html += '<tr><td style=\"width:70px\" valign=\"top\"><img src=\"' + SUTC.ASSETS_URL + 'sutc/icon-check-list.png\"></td>';
            html += '<td><h3 style=\"padding-bottom:0;padding-top:0;margin-bottom:0;margin-top:0;font:200 20px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#df5546\">';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#hepatitis\" style=\"text-decoration:none;color:#df5546;\">';
            html += 'Hepatitis B and C Screening ';
            html += '</a>';
            html += '</h3><p style=\"padding-top:0;margin-top:6px;font:normal 15px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#4d4d4d\">';
            html += 'Left unchecked, these liver infections can lead to serious damage, even liver cancer. If you’re positive, your doctor can start you on treatment.  ';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#hepatitis\" style=\"text-decoration:none;color:#df5546;white-space:nowrap;\">Learn More.</a></p>';
            html += '</td></tr>';
            html += '</tbody></table>';
        return html;
    }

    public static String htmlBreastCancerGeneticTesting () {
        String html = '<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"padding-bottom:10px\"><tbody>';
            html += '<tr><td style=\"width:70px\" valign=\"top\"><img src=\"' + SUTC.ASSETS_URL + 'sutc/icon-breast-genetic.png\"></td>';
            html += '<td><h3 style=\"padding-bottom:0;padding-top:0;margin-bottom:0;margin-top:0;font:200 20px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#df5546\">';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#breast-cancer-genetic\" style=\"text-decoration:none;color:#df5546;\">';
            html += 'Breast Cancer Counseling and Genetic Testing';
            html += '</a>';
            html += '</h3><p style=\"padding-top:0;margin-top:6px;font:normal 15px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#4d4d4d\">';
            html += 'If your family history suggests a higher risk of breast cancer, your doctor may recommend counseling and tests. ';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#breast-cancer-genetic\" style=\"text-decoration:none;color:#df5546;white-space:nowrap;\">Learn More.</a></p>';
            html += '</td></tr>';
            html += '</tbody></table>';
        return html;
    }

    public static String htmlAnnualExam () {
        String html = '<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"padding-bottom:10px\"><tbody>';
            html += '<tr><td style=\"width:70px\" valign=\"top\"><img src=\"' + SUTC.ASSETS_URL + 'sutc/icon-check-list.png\"></td>';
            html += '<td><h3 style=\"padding-bottom:0;padding-top:0;margin-bottom:0;margin-top:0;font:200 20px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#df5546\">';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#annual-exam\" style=\"text-decoration:none;color:#df5546;\">';
            html += 'Annual Exam ';
            html += '</a>';
            html += '</h3><p style=\"padding-top:0;margin-top:6px;font:normal 15px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#4d4d4d\">';
            html += 'Even if you’re healthy, it’s a good idea to visit your doctor every year or so for preventive care. It’s also good chance to chat about anything on your mind. ';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#annual-exam\" style=\"text-decoration:none;color:#df5546;white-space:nowrap;\">Learn More.</a></p>';
            html += '</td></tr>';
            html += '</tbody></table>';
        return html;
    }

    public static String htmlVaccinationHPVCancer () {
        String html = '<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"padding-bottom:10px\"><tbody>';
            html += '<tr><td style=\"width:70px\" valign=\"top\"><img src=\"' + SUTC.ASSETS_URL + 'sutc/icon-med-chart.png\"></td>';
            html += '<td><h3 style=\"padding-bottom:0;padding-top:0;margin-bottom:0;margin-top:0;font:200 20px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#4d4d4d\">';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#hpv-vaccine\" style=\"text-decoration:none;color:#4d4d4d;\">';
            html += 'Human Papillomavirus (HPV) Vaccine ';
            html += '</a>';
            html += '</h3><p style=\"padding-top:0;margin-top:6px;font:normal 15px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#4d4d4d\">';
            html += 'HPV vaccine can prevent most genital warts and most cases of cervical cancer. Protection from HPV vaccine is expected to be long - lasting. But vaccinated women still need cervical cancer screenings because the vaccine does not protect against all HPV types that cause cervical cancer. ';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#hpv-vaccine\" style=\"text-decoration:none;color:#df5546;white-space:nowrap;\">Learn More.</a></p>';
            html += '</td></tr>';
            html += '</tbody></table>';
        return html;
    }

    public static String htmlVaccinationHBVCancer () {
        String html = '<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"padding-bottom:10px\"><tbody>';
            html += '<tr><td style=\"width:70px\" valign=\"top\"><img src=\"' + SUTC.ASSETS_URL + 'sutc/icon-test-tubes.png\"></td>';
            html += '<td><h3 style=\"padding-bottom:0;padding-top:0;margin-bottom:0;margin-top:0;font:200 20px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#4d4d4d\">';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#hbv-vaccine\" style=\"text-decoration:none;color:#4d4d4d;\">';
            html += 'Hepatitis B (HBV) Vaccine ';
            html += '</a>';
            html += '</h3><p style=\"padding-top:0;margin-top:6px;font:normal 15px \'Helvetica Neue\',Helvetica,Arial,sans-serif;color:#4d4d4d\">';
            html += 'Anyone who wants to avoid this liver infection should consider the hepatitis B vaccine. It’s especially important for certain people — find out if you might need it. ';
            html += '<a href=\"' + SUTC.SURVEY_URL + '#hbv-vaccine\" style=\"text-decoration:none;color:#df5546;white-space:nowrap;\">Learn More.</a></p>';
            html += '</td></tr>';
            html += '</tbody></table>';
        return html;
    }

    public static String htmlTemplate(String email, String firstname, Decimal age, String sex) {
        String msg = '<html>';
            msg += '<head><title>Thanks for Taking the Pledge!</title></head>';
            msg += '<body style=\"margin: 0; padding: 0;\">';
            msg += '<div style=\"width: 100%; text-align: left;\">';
            msg += '<div style=\"font: normal 11px \'Helvetica Neue\', Helvetica, Arial, sans-serif; border-bottom: 20px solid #4d4d4d; line-height: 16px; text-align: center;\">Here\'s your health checklist from Rally!</div>';
            msg += '<!--[if mso]>';
            msg += '<center >';
            msg += '<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"center\" width=\"600\">';
            msg += '<![endif]-->';
            msg += '<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"center\" style=\"max-width: 600px;\">';
                msg += '<tr>';
                    msg += '<td style=\"padding: 25px 30px; text-align: left;\">';
                    msg += '<img src=\"' + SUTC.ASSETS_URL + 'sutc/sutc-email-logo.gif\" height=\"30\">';
                    msg += '</td>';
                msg += '</tr>';
                msg += '<tr>';
                    msg += '<td><img src=\"' + SUTC.ASSETS_URL + 'sutc/sutc-email-logo.png\" width=\"100%\" style=\"width: 100%;\"></td>';
                msg += '</tr>';
                msg += '<tr>';
                    msg += '<td style=\"padding: 10px 30px; background-image: url(' + SUTC.ASSETS_URL + 'sutc/sutc-background.gif);\">';
                    msg += '<div style=\"padding-bottom: 50px; border-bottom: 1px solid #4d4d4d; font: normal 15px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">';
                    msg += '<p style=\"font: normal 15px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Hi ';
                    msg += firstname + ',</p>';
                    msg += '<p style=\"font: normal 15px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Thanks for joining Rally and Stand Up To Cancer and taking the Pledge to get the screenings you need! As promised, here is your personalized list of recommended health screenings and vaccinations.</p>';
                    msg += '<p style=\"padding-bottom: 0; margin-bottom: 0; font: normal 15px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Depending on your health plan, screenings and vaccinations may be available to you at no additional cost.</p>';
                    msg += '</div>';
                    msg += '<div style=\"font: normal 15px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">';
                    msg += '<h2 style=\"margin: 0; padding: 15px 0 30px 0; font: 200 24px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Screenings</h2>';
                    if ((age >= SUTC.AGE_FLOOR_MAMMOGRAM) && (age <= SUTC.AGE_CEILING_MAMMOGRAM) && (sex == SUTC.SEX_FEMALE)) { msg += htmlScreeningBreastCancer(); }
                    if ((age >= SUTC.AGE_FLOOR_PAP_TEST) && (age <= SUTC.AGE_CEILING_PAP_TEST) && (sex == SUTC.SEX_FEMALE)) { msg += htmlScreeningCervicalCancer(); }
                    if ((age >= SUTC.AGE_FLOOR_COLONOSCOPY) && (age <= SUTC.AGE_CEILING_COLONOSCOPY)) { msg += htmlScreeningColorectalCancer(); }
                    msg += htmlScreeningHepatitis();
                    if ((age >= SUTC.AGE_ADULT) && (age <= SUTC.AGE_MAX) && (sex == SUTC.SEX_FEMALE) ) { msg += htmlBreastCancerGeneticTesting(); }
                    msg += htmlAnnualExam();
                    msg += '<div style=\"height: 20px; border-bottom: 1px solid #4d4d4d;\">&nbsp;</div>';

                    msg += '<h2 style=\"margin: 0; padding: 15px 0 30px 0; font: 200 24px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Vaccinations</h2>';
                    if ((age >= SUTC.AGE_ADULT) && (age <= SUTC.AGE_CEILING_HPV)) { msg += htmlVaccinationHPVCancer(); }
                    msg += htmlVaccinationHBVCancer();
                    msg += '<div style=\"height: 20px; border-bottom: 1px solid #4d4d4d;\">&nbsp;</div>';

                    msg += '<h2 style=\"margin: 0; padding: 15px 0 30px 0; font: 200 24px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Healthy Living Tips</h2>';

                    // Don't Smoke
                    msg += '<a href=\"' + SUTC.SURVEY_URL + '#smoking\" style=\"text-decoration: none; color: #df5546;white-space:nowrap;\">';
                    msg += '<h3 style=\"padding: 0; margin: 0; font: 200 20px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Don\'t Smoke</h3>';
                    msg += '</a>';
                    msg += '<p style=\"padding-top: 0; margin-top: 5px; font: normal 15px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Do not smoke cigarettes or use other tobacco products, which are not safe either. E-cigarettes are probably not safe because they contain nicotine and other carcinogens. The good news: Just five years after you quit smoking, your cancer risks start to go down. <a href=\"' + SUTC.SURVEY_URL + '#smoking\" style=\"text-decoration: none; color: #df5546;white-space:nowrap;\">Learn More.</a></p>';
                    // Avoid Too Much Sun
                    msg += '<a href=\"' + SUTC.SURVEY_URL + '#sun\" style=\"text-decoration: none; color: #df5546;white-space:nowrap;\">';
                    msg += '<h3 style=\"padding: 0; margin: 30px 0 0 0; font: 200 20px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Avoid Too Much Sun</h3>';
                    msg += '</a>';
                    msg += '<p style=\"padding-top: 0; margin-top: 5px; font: normal 15px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Stay safe out there, and just say no to tanning beds. Check our tips for sunscreen and more, and learn how to spot dangerous moles. <a href=\"' + SUTC.SURVEY_URL + '#sun\" style=\"text-decoration: none; color: #df5546;white-space:nowrap;\">Learn More.</a></p>';
                    // Be a Smart Eater
                    msg += '<a href=\"' + SUTC.SURVEY_URL + '#eating\" style=\"text-decoration: none; color: #df5546;white-space:nowrap;\">';
                    msg += '<h3 style=\"padding: 0; margin: 30px 0 0 0; font: 200 20px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Be a Smart Eater</h3>';
                    msg += '</a>';
                    msg += '<p style=\"padding-top: 0; margin-top: 5px; font: normal 15px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">That means lots of plant foods — whole grains, veggies, fruit, nuts, and beans. And watch out for salt! See all our simple shopping and cooking tips. <a href=\"' + SUTC.SURVEY_URL + '#eating\" style=\"text-decoration: none; color: #df5546;white-space:nowrap;\">Learn More.</a></p>';
                    // Fit in Regular Exercise
                    msg += '<a href=\"' + SUTC.SURVEY_URL + '#exercise\" style=\"text-decoration: none; color: #df5546;white-space:nowrap;\">';
                    msg += '<h3 style=\"padding: 0; margin: 30px 0 0 0; font: 200 20px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Fit in Regular Exercise</h3>';
                    msg += '</a>';
                    msg += '<p style=\"padding-top: 0; margin-top: 5px; font: normal 15px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">It\'s good for your weight, mood, blood sugar, and yes, it can lower your risk of 13 types of cancers. Intensity seems to count, so work it! <a href=\"' + SUTC.SURVEY_URL + '#exercise\" style=\"text-decoration: none; color: #df5546;white-space:nowrap;\">Learn More.</a></p>';
                    // Keep Your Weight In Check
                    msg += '<a href=\"' + SUTC.SURVEY_URL + '#weight\" style=\"text-decoration: none; color: #df5546;white-space:nowrap;\">';
                    msg += '<h3 style=\"padding: 0; margin: 30px 0 0 0; font: 200 20px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Keep Your Weight In Check</h3>';
                    msg += '</a>';
                    msg += '<p style=\"padding-top: 0; margin-top: 5px; font: normal 15px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">It doesn\'t take much: If everyone lost just 1 percent of their weight, it could prevent 100,000 cases of cancer. If you\'re already slim, try to keep it that way. <a href=\"' + SUTC.SURVEY_URL + '#weight\" style=\"text-decoration: none; color: #df5546;white-space:nowrap;\">Learn More.</a></p>';
                    // Mind Your Drinking
                    msg += '<a href=\"' + SUTC.SURVEY_URL + '#drinking\" style=\"text-decoration: none; color: #df5546;white-space:nowrap;\">';
                    msg += '<h3 style=\"padding: 0; margin: 30px 0 0 0; font: 200 20px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Mind Your Drinking</h3>';
                    msg += '</a>';
                    msg += '<p style=\"padding-top: 0; margin-top: 5px; font: normal 15px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Happy hour can be tempting but cancer trouble can start at just one alcoholic drink a day for women, or two for men. Find out what counts as \"one drink.\" <a href=\"' + SUTC.SURVEY_URL + '#drinking\" style=\"text-decoration: none; color: #df5546;white-space:nowrap;\">Learn More.</a></p>';

                    msg += '<p style=\"padding-top: 0; margin-top: 0; font: normal 15px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">Take care of yourself!</p>';
                    msg += '<p style=\"padding-bottom: 50px; margin-bottom: 0; font: normal 15px \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #4d4d4d;\">&mdash;Your friends at Rally</p>';

                    msg += '<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td align=\"center\" style=\"vertical-align: bottom;\">';
                    msg += '<a href=\"http://www.standup2cancer.org\" style=\"text-decoration: none; color: #4d4d4d;\"><img src=\"' + SUTC.ASSETS_URL + 'sutc/stand-up-to-cancer-logo.png\" border=\"0\">';
                    msg += '<div style=\"padding: 15px 40px 15px 40px; font-size: 18px; font-weight: 200;\">Find out more about Stand Up To Cancer<img src=\"' + SUTC.ASSETS_URL + 'sutc/arrow.png\" style=\"vertical-align: middle;\"></div></a></td>';
                    msg += '<td align=\"center\" style=\"vertical-align: bottom;\">';
                    msg += '<a href=\"https://www.rallyhealth.com\" style=\"text-decoration: none; color: #4d4d4d;\"><img src=\"' + SUTC.ASSETS_URL + 'sutc/Rally-logo.png\" border=\"0\">';
                    msg += '<div style=\"padding: 15px 40px 15px 40px; font-size: 18px; font-weight: 200;\">Find out more about Rally Health<img src=\"' + SUTC.ASSETS_URL + 'sutc/arrow.png\" style=\"vertical-align: middle;\"></div></a></td></tr></table>';

                    msg += '<div style=\"height: 50px;\">&nbsp;</div>';

                    msg += '<div style=\"padding: 20px 0 0 0; border-top: 1px solid #4d4d4d; font-size: 11px;\">';
                    msg += '<p style=\"color:#4d4d4d;\">This message was sent to ' + email + ' </p>';

                    msg += '<p style=\"color: #4d4d4d;\"><a href=\"https://www.rallyhealth.com\" style=\"text-decoration: none; color: #4d4d4d;\">Rally</a> is a service mark of Rally Health, Inc.<br>';
                    msg += '3000 K Street, NW | Suite 350 | Washington, DC 20007</p>';
                    msg += '</div>';
                    msg += '</div>';
                    msg += '</td>';
                msg += '</tr>';
            msg += '</table>';
            msg += '<!--[if mso]>';
            msg += '</center>';
            msg += '</table>';
            msg += '<![endif]-->';
        msg += '</body>';
        msg += '</html>';

        return msg;
    }
}