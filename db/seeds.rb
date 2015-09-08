name = 'Default theme' 
body = '<table id=\"bodyTable\" height=\"100%\" align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">
     <tbody>
        <tr>
           <td id=\"bodyCell\" align=\"center\" valign=\"top\">
              <!-- BEGIN TEMPLATE // -->
              <table id=\"templateContainer\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\">
                 <tbody>
                    <tr>
                       <td align=\"center\" valign=\"top\">
                          <!-- BEGIN PREHEADER // -->
                          <table id=\"templatePreheader\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\">
                             <tbody>
                                <tr>
                                   <td mccontainer=\"preheader_container\" mc:container=\"preheader_container\" style=\"padding-top:9px;\" class=\"preheaderContainer tpl-container chaskiqDndSource chaskiqDndTarget chaskiqDndContainer\" valign=\"top\">
                                      <div class=\"chaskiqContainerEmptyMessage\" style=\"display: block;\">Drop Content Blocks Here</div>
                                   </td>
                                </tr>
                             </tbody>
                          </table>
                          <!-- // END PREHEADER -->
                       </td>
                    </tr>
                    <tr>
                       <td align=\"center\" valign=\"top\">
                          <!-- BEGIN HEADER // -->
                          <table id=\"templateHeader\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\">
                             <tbody>
                                <tr>
                                   <td mccontainer=\"header_container\" mc:container=\"header_container\" class=\"headerContainer tpl-container chaskiqDndSource chaskiqDndTarget chaskiqDndContainer\" valign=\"top\">
                                      <div class=\"chaskiqContainerEmptyMessage\" style=\"display: block;\">Drop Content Blocks Here</div>
                                   </td>
                                </tr>
                             </tbody>
                          </table>
                          <!-- // END HEADER -->
                       </td>
                    </tr>
                    <tr>
                       <td align=\"center\" valign=\"top\">
                          <!-- BEGIN BODY // -->
                          <table id=\"templateBody\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\">
                             <tbody>
                                <tr>
                                   <td mccontainer=\"body_container\" mc:container=\"body_container\" class=\"bodyContainer tpl-container chaskiqDndSource chaskiqDndTarget chaskiqDndContainer\" valign=\"top\">
                                      <div class=\"chaskiqContainerEmptyMessage\" style=\"display: block;\">Drop Content Blocks Here</div>
                                   </td>
                                </tr>
                             </tbody>
                          </table>
                          <!-- // END BODY -->
                       </td>
                    </tr>
                    <tr>
                       <td align=\"center\" valign=\"top\">
                          <!-- BEGIN FOOTER // -->
                          <table id=\"templateFooter\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\">
                             <tbody>
                                <tr>
                                   <td mccontainer=\"footer_container\" style=\"padding-bottom:9px;\" mc:container=\"footer_container\" class=\"footerContainer tpl-container chaskiqDndSource chaskiqDndTarget chaskiqDndContainer\" valign=\"top\">
                                      <div class=\"chaskiqContainerEmptyMessage\" style=\"display: block;\">Drop Content Blocks Here</div>
                                      <div class=\"chaskiqBlock tpl-block chaskiqDndItem focus\">
                                         <div data-chaskiq-attach-point=\"containerNode\">
                                            <table class=\"mcnTextBlock\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">
                                               <tbody class=\"mcnTextBlockOuter\">
                                                  <tr>
                                                     <td class=\"mcnTextBlockInner\" valign=\"top\">
                                                        <table class=\"mcnTextContentContainer\" align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\">
                                                           <tbody>
                                                              <tr>
                                                                 <td style=\"padding-top:9px; padding-right: 18px; padding-bottom: 9px; padding-left: 18px;\" class=\"mcnTextContent\" valign=\"top\"> <em>©</em> {{campaign_description}} <br> <br> <strong>Our mailing address is:</strong><br> {{campaign_url}} <br> <br> <a href=\"{{campaign_unsubscribe}}\" class=\"utilityLink\">unsubscribe from this list</a>&nbsp;&nbsp;&nbsp; <a href=\"{{campaign_unsubscribe}}\" class=\"utilityLink\">update subscription preferences</a>&nbsp;<br> <br> </td>
                                                              </tr>
                                                           </tbody>
                                                        </table>
                                                     </td>
                                                  </tr>
                                               </tbody>
                                            </table>
                                         </div>
                                         <div class=\"tpl-block-controls\"> <span class=\"tpl-block-drag chaskiqDndHandle freddicon vellip-square\" title=\"Drag to Reorder\"></span> <a data-chaskiq-attach-point=\"editBtn\" class=\"tpl-block-edit\" href=\"#\" title=\"Edit Block\"><i class=\"fa fa-edit\"></i></a> <a data-chaskiq-attach-point=\"cloneBtn\" class=\"tpl-block-clone\" href=\"#\" title=\"Duplicate Block\"><i class=\"fa fa-files-o\"></i></a> <a data-chaskiq-attach-point=\"deleteBtn\" class=\"tpl-block-delete\" href=\"#\" title=\"Delete Block\"><i class=\"fa fa-trash\"></i></a> </div>
                                      </div>
                                   </td>
                                </tr>
                             </tbody>
                          </table>
                          <!-- // END FOOTER -->
                       </td>
                    </tr>
                 </tbody>
              </table>
              <!-- // END TEMPLATE -->
           </td>
        </tr>
     </tbody>
     </table>'
css = '#bodyTable {background-color: #f2f2f2;}
        #templatePreheader,
        #templateHeader,
        #templateColumns,
        #templateFooter,
        #templateBody{
        background-color: #ffffff;
        border-bottom: 0 none;
        border-top: 0 none;
        }
        .footerContainer .mcnTextContent a {
        color: #606060;
        font-weight: normal;
        text-decoration: underline;
        }
        .footerContainer .mcnTextContent, .footerContainer .mcnTextContent p {
        color: #606060;
        font-family: Helvetica;
        font-size: 11px;
        line-height: 125%;
        text-align: left;
        }

        .chaskiqContainerEmptyMessage{
          overflow:hidden; 
          float:left; 
          display:none; 
          line-height:0px;
        }'


Chaskiq::Template.create(body: body , name: name, css: css)
