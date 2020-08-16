using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using backendPoSlojevima.Data;

namespace backendPoSlojevima.UI
{
    public class KategorijeProblemaUI : IKategorijeProblemaUI
    {
        private readonly IKategorijeProblemaBL _IKategorijaProblemaBL;

        public KategorijeProblemaUI (IKategorijeProblemaBL IKategorijaProblemaBL)
        {
            _IKategorijaProblemaBL = IKategorijaProblemaBL;
        }

        public KategorijeProblema getkategorijaById(long idKategorije)
        {
            return _IKategorijaProblemaBL.getkategorijaById(idKategorije);
        }

        public List<KategorijeProblema> getKategorijeByListaId(List<long> lista)
        {
            return _IKategorijaProblemaBL.getKategorijeByListaId(lista);
        }

        public List<KategorijeProblema> getKategorijeProblema()
        {
            return _IKategorijaProblemaBL.getKategorijeProblema();
        }
    }
}
