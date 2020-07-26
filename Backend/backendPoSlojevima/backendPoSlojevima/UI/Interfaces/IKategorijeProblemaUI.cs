using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface IKategorijeProblemaUI
    {
        public List<KategorijeProblema> getKategorijeProblema();
        public List<KategorijeProblema> getKategorijeByListaId(List<long> lista);
        public KategorijeProblema getkategorijaById(long idKategorije);

    }
}
