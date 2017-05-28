var num = 10;
var data;
var page;

$(function() {
  // 权限
  rankDeal();

  // 寻找参数
  var name = getQueryVariable('drug_name');
  if (name != false) {
    name = decodeURI(name).replace('百分号', '%');
    $('#keyword').val(name);
  }

  // 搜索按钮
  $('#btnSearch').click(function() {
    Webservice_Drug.GetDrugMix(id, pw, $('#keyword').val(), setTable);
    return false;
  }).click();

  // 换页
  $('#page').on('click', 'li', paging);

  // 详细框
  initModal();

});

// 初始化模态框
function initModal() {
  $('#result tbody').on('click', 'tr', showModal);
  // 关闭
  $('#detailModal .close, #detailModal').click(hideModal);
  $('#detailModal .modal_container').click(function() {
    return false;
  });
  // 切换页面
  $('#detailModal .modal_header ul').on('click', 'li:not(.active)', changePane);
}

// 切换页面
function changePane() {
  $('#detailModal .modal_header ul li').removeClass('active');
  $(this).addClass('active');
  $('#detailModal .modal_container .modal_main').removeClass('active');
  $('#' + $(this).attr('data-id')).addClass('active');
}

// URL参数
function getQueryVariable(variable) {
  var query = window.location.search.substring(1);
  var vars = query.split('&');
  for (var i = 0; i < vars.length; i++) {
    var pair = vars[i].split('=');
    if (pair[0] == variable) {return pair[1];}
  }
  return (false);
}

// 隐藏并刷新搜索
function hideModal() {
  $('#detailModal').css('visibility', 'hidden');
  $('#btnSearch').click();
  return false;
}

// 显示模态框并填充数据
function showModal() {
  var name = $(this).closest('tr').find('td').html();
  $('#detailModal').css('visibility', 'visible');
  $('li[data-id=basePane]').click();
  // 基本信息
  Webservice_Drug.GetDrugMixByName(id, pw, name, setBasePane);
  // 配方表
  Webservice_Drug.GetDrugMix_Struct(id, pw, name, setRecipePane);
  $('#inRecipeDrug').val('');
  $('#btnRecipeDrug').click();
  $('#inRecipeMix').val('');
  $('#btnRecipeMix').click();
  // 计算用量
  Webservice_Drug.GetDrugMix_Struct(id, pw, name, setCountPane);
}

// 设置计算用量
function setCountPane(result) {
  var temp = $('#drug_container').html('');
  $('#calculator input').val('0');
  if (result != '') {
    result = JSON.parse(result);
    for (var re in result) {
      temp.append('<div class="drug_item"><span>' + result[re].drug_name +
       '</span> <strong data-base="' + result[re].num + '">0</strong>' +
       result[re].standard + '<button>详情</button></div>');
    }
  }else {
    temp.append('<div class="drug_item">暂无配方信息</div>');
  }
}

// 设置基本信息
function setBasePane(result) {
  result = JSON.parse(result)[0];
  $('#detailModal').attr('data-name', result.drug_mix);
  var inputs = $('#basePane input, #basePane textarea');
  $(inputs[0]).val(result.drug_mix);
  $(inputs[1]).val(result.standard);
  $(inputs[2]).val(result.attention);
  // 计算用量
  $('#calculator span').html(result.drug_mix);
  $('#calculator i').html(result.standard);
}

function setRecipePane(result) {
  $('#btnFindDrug').click();
  $('#recipeMixInfo').html('<li>暂无试剂信息</li>');
  var temp = $('#recipeDrugInfo').html('');
  if (result != '') {
    result = JSON.parse(result);
    for (var re in result) {
      if (manager == 2) {
        temp.append('<li><span>' + result[re].drug_name + '</span> ' +
          '<span>' + result[re].num + '</span><span>' + result[re].standard +
          '</span><button class="btnDelDrug">删除</button>' +
          '<button class="btnDetailDrug">详情</button></li>');
      }else {
        temp.append('<li><span>' + result[re].drug_name + '</span> ' +
          '<span>' + result[re].num + '</span><span>' + result[re].standard +
          '</span></li>');
      }
    }
  }else {
    temp.append('<li>暂无药品信息</li>');
  }
}

// 换页
function paging() {
  if ($(this).html() == '...') {
    return;
  }
  if ($(this).html() == '&gt;&gt;') {
    page++;
  } else if ($(this).html() == '&lt;&lt;') {
    page--;
  } else {
    page = parseInt($(this).html());
  }
  setPage();
  setData();
}

// 响应搜索
function setTable(result) {
  data = [];
  if (result != '') {
    result = JSON.parse(result);
    var count = 0;
    for (var re in result) {
      data[count++] = result[re];
    }
  }
  page = 0;
  setPage();
  setData();
}

// 分页处理
function setPage() {
  $('#page').html('');
  var l = Math.ceil(data.length / num);
  if (l <= 0) {
    return;
  }
  if (page > l) {
    page = l;
  } else if (page <= 0) {
    page = 1;
  }
  if (l == 1) {
    $('#page').append('<li class="active">1</li>');
  } else {
    var s = (page - 2 < 1) ? 1 : page - 2;
    var e = (s + 4 > l) ? l : s + 4;
    s = (e - 4 < 1) ? 1 : e - 4;
    if (s != page) {
      $('#page').append('<li><<</li>');
    }
    if (s > 1) {
      $('#page').append('<li>...</li>');
    }
    for (var i = s ; i <= e; i++) {
      if (page == i) {
        $('#page').append('<li class="active">' + i + '</li>');
      }else {
        $('#page').append('<li>' + i + '</li>');
      }
    }
    if (e < l) {
      $('#page').append('<li>...</li>');
    }
    if (e != page) {
      $('#page').append('<li>>></li>');
    }
  }
}

// 填充数据
function setData() {
  $('#result tbody').html('');
  if (Math.ceil(data.length / num) == 0) {
    $('#result tbody').append('<tr><td colspan="3">无查找结果</td></tr>');
    return;
  }
  for (var i = (page - 1) * num; i < page * num && i < data.length; i++) {
    var temp = $('<tr>');
    temp.append('<td>' + data[i].drug_mix + '</td>');
    temp.append('<td>' + data[i].attention + '</td>');
    $('#result tbody').append(temp);
  }
}

// 权限处理
function rankDeal() {
  // 权限分类
  switch (manager) {
    case '管理权限':
      manager = 2;
      break;
    case '一般权限':
      manager = 1;
      break;
    default:
      manager = 0;
      break;
  }
  // 界面设计
  if (manager == 2) {
    // 基本信息
    $('#basePane input, #basePane textarea').removeAttr('disabled');
    $('#basePane').append('<div class="full"><button id="btnChangeBase">' +
      '确认修改</button></div>');
    $('#btnChangeBase').click(changeBase);
    // 配方表
    $('#recipeDrug ul').on('click', 'li', function(e) {
        if ($(this).hasClass('active')) {
          $(this).removeClass('active');
        }else {
          $('#recipeDrug ul li').removeClass('active');
          $(this).addClass('active');
        }
      });
    $('#recipeInfo').append('<button id="btnChangeRecipe">确认修改</button>');
    $('#btnChangeRecipe').click(changeRecipe);
    $('#btnRecipeDrug').click(searchDrug); // 搜索药品
    $('#btnAddDrug').click(addDrug); // 添加药品
    $('#btnDrugDetail').click(drugDetail); // 药品详情
    $('#btnFindMix').click(findMix); // 查找试剂
    $('#recipeMix ul').on('click', 'li', function(e) {
        if ($(this).hasClass('active')) {
          $(this).removeClass('active');
        }else {
          $('#recipeMix ul li').removeClass('active');
          $(this).addClass('active');
        }
      });
    $('#btnRecipeMix').click(searchMix); // 搜索试剂
    $('#btnAddMix').click(addMix); // 添加试剂
    $('#btnMixDetail').click(mixDetail); // 试剂详情
    $('#btnFindDrug').click(findDrug); // 查找药品
  } else {
    // 配方表
    $('#recipeSearch').remove();
  }
  // 药品详情
  $('#recipeDrugInfo').on('click', 'button.btnDetailDrug', detailDrug);
  $('#recipeMixInfo').on('click', 'button.btnDetailMix', detailMix);
  $('#recipeDrugInfo').on('click', 'button.btnDelDrug', delDrug);
  $('#recipeMixInfo').on('click', 'button.btnDelMix', delMix);
  // 计算用量
  $('#drug_container').on('click', 'button', detailDrug);
  $('#calculator input').on('input',  countNum);
}

// 计算用量
function countNum() {
  var mul = parseFloat($('#calculator input').val());
  mul = (isNaN(mul)) ? 0 : mul;
  var lists = $('#drug_container>div.drug_item');
  for (var i = 0; i < lists.length; i++) {
    var sp = $(lists[i]).find('strong');
    sp.html((parseFloat(sp.attr('data-base')) * mul).toFixed(2));
  }
}

// 删除试剂
function delMix() {
  $(this).parent().remove();
  if ($('#recipeMixInfo li').length == 0) {
    $('#recipeMixInfo').html('<li>暂无试剂信息</li>');
  }
}

// 删除药品
function delDrug() {
  $(this).parent().remove();
  if ($('#recipeDrugInfo li').length == 0) {
    $('#recipeDrugInfo').html('<li>暂无药品信息</li>');
  }
}

// 配方表 - 试剂详情
function detailMix() {
  var temp = $(this).parent().find('span').eq(0).html();
  window.open('Drug_Mix.aspx?drug_name=' + temp.replace('%', '百分号'));
}

// 配方表 - 药品详情
function detailDrug() {
  var temp = $(this).parent().find('span').eq(0).html();
  window.open('Drug_Info.aspx?drug_name=' + temp.replace('%', '百分号'));
}

// 查找药品
function findDrug() {
  $('#recipeSearch article').css('top', '0');
}

// 试剂详情
function mixDetail() {
  var temp = $('#recipeMix ul li.active')[0];
  if (temp) {
    temp = $(temp).find('span').html().replace('%', '百分号');
    window.open('Drug_Mix.aspx?drug_name=' + temp);
  }
}

// 添加试剂
function addMix() {
  var temp = $('#recipeMix ul li.active')[0];
  if (temp) {
    if ($('#recipeMixInfo li:first-child').html() == '暂无试剂信息') {
      $('#recipeMixInfo').html('');
    }
    temp = $(temp);
    var tarName = temp.find('span').html();
    var lists = $('#recipeMixInfo li');
    for (var i = 0; i < lists.length; i++) {
      var tepName = $($(lists[i]).find('span')[0]).html();
      if (tarName == tepName) {
        var a = temp.find('input').val();
        var b = $($(lists[i]).find('span')[1]).html();
        var c = parseFloat(a) + parseFloat(b);
        $($(lists[i]).find('span')[1]).html(c);
        return;
      }
    }
    var item = $('<li>');
    item.append('<span>' + temp.find('span').html() + '</span> ');
    item.append('<span>' + temp.find('input').val() + '</span>');
    item.append('<span>' + temp.find('i').html() + '</span>');
    item.append('<button class="btnDelMix">删除</button');
    item.append('<button class="btnDetailMix">详情</button>');
    $('#recipeMixInfo').append(item);
  }
}

// 搜索试剂
function searchMix() {
  var temp = $('#inRecipeMix').val();
  Webservice_Drug.GetDrugMix(id, pw, temp, function(result) {
      var list = $('#recipeMix ul').html('');
      result = JSON.parse(result);
      for (var re in result) {
        var item = $('<li>');
        item.append('<span>' + result[re].drug_mix + '</span>');
        item.append('<i>' + result[re].standard + '</i>');
        item.append('<input type="text">');
        list.append(item);
      }
    });
}

// 查找试剂
function findMix() {
  $('#recipeSearch article').css('top', '-100%');
}

// 药品详情
function drugDetail() {
  var temp = $('#recipeDrug ul li.active')[0];
  if (temp) {
    temp = $(temp).find('span').html().replace('%', '百分号');
    window.open('Drug_Info.aspx?drug_name=' + temp);
  }
}

// 添加药品
function addDrug() {
  var temp = $('#recipeDrug ul li.active')[0];
  if (temp) {
    if ($('#recipeDrugInfo li:first-child').html() == '暂无药品信息') {
      $('#recipeDrugInfo').html('');
    }
    temp = $(temp);
    var tarName = temp.find('span').html();
    var lists = $('#recipeDrugInfo li');
    for (var i = 0; i < lists.length; i++) {
      var tepName = $($(lists[i]).find('span')[0]).html();
      if (tarName == tepName) {
        var a = temp.find('input').val();
        var b = $($(lists[i]).find('span')[1]).html();
        var c = parseFloat(a) + parseFloat(b);
        $($(lists[i]).find('span')[1]).html(c);
        return;
      }
    }
    var item = $('<li>');
    item.append('<span>' + temp.find('span').html() + '</span> ');
    item.append('<span>' + temp.find('input').val() + '</span>');
    item.append('<span>' + temp.find('i').html() + '</span>');
    item.append('<button class="btnDelDrug">删除</button');
    item.append('<button class="btnDetailDrug">详情</button>');
    $('#recipeDrugInfo').append(item);
  }
}

// 搜索药品
function searchDrug() {
  var temp = $('#inRecipeDrug').val();
  Webservice_Drug.GetDrug(id, pw, temp, function(result) {
      var list = $('#recipeDrug ul').html('');
      result = JSON.parse(result);
      for (var re in result) {
        var item = $('<li>');
        item.append('<span>' + result[re].drug_name + '</span>');
        item.append('<i>' + result[re].standard + '</i>');
        item.append('<input type="text">');
        list.append(item);
      }
    });
}

// 更改基本信息
function changeBase() {
  var inputs = $('#basePane input, #basePane textarea');
  var temp = [{
      'drug_mix': $(inputs[0]).val(),
      'standard': $(inputs[1]).val(),
      'attention': $(inputs[2]).val()
    }];
  Webservice_Drug.DrugMix_Insert_Update(id, pw, JSON.stringify(temp),
    $('#detailModal').attr('data-name'), function(result) {
        alert(result);
        hideModal();
      });
}

// 确认修改
function changeRecipe() {
  var tempDrug = [];
  var tempList = $('#recipeDrugInfo li');
  if ($(tempList[0]).html() == '暂无药品信息') {
    tempDrug = '';
  } else {
    for (var i = 0; i < tempList.length; i++) {
      var tempObj = {
          'drug_mix': $('#detailModal').attr('data-name'),
          'drug_name': $(tempList[i]).find('span').eq(0).html(),
          'num': $(tempList[i]).find('span').eq(1).html(),
          'standard': $(tempList[i]).find('span').eq(2).html()
        };
      tempDrug.push(tempObj);
    }
    tempDrug  = JSON.stringify(tempDrug);
  }

  var tempMix = [];
  tempList = $('#recipeMixInfo li');
  if ($(tempList[0]).html() == '暂无试剂信息') {
    tempMix = '';
  } else {
    for (var i = 0; i < tempList.length; i++) {
      var tempObj = {
          'drug_mix': $(tempList[i]).find('span').eq(0).html(),
          'num': $(tempList[i]).find('span').eq(1).html(),
          'standard': $(tempList[i]).find('span').eq(2).html()
        };
      tempMix.push(tempObj);
    }
    tempMix = JSON.stringify(tempMix);
  }

  Webservice_Drug.DrugMixDrug_Insert_Update(id, pw, tempDrug, tempMix,
  $('#detailModal').attr('data-name'), function(result) {
    alert(result);
    hideModal();
  });
}
